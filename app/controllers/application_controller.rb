class ApplicationController < ActionController::Base
  # allow_browser versions: { chrome: 80, firefox: 100, safari: 12.1, ie: false, edge: 106 } # TODO: choose sensible versions
  protect_from_forgery prepend: true

  # Detailed error pages must only be used in development! By default use our custom (less informative) error pages
  include ErrorHandler unless AppConf.is?(:debug, true) && !AppConf.production_env

  include Authentication # sets current_user, based on the session, provides sign_in / sign_out
  include Logins # records the login, keeps only a few recent sessions, allows users to delete other sessions
  include TeamScope # sets current_team & current_member, based on the session, provides switch_current_team / go_solo
  include RequestContext # sets the Current.objects, partly based on current_user and current_team

  # see: https://actionpolicy.evilmartians.io/#/rails
  #
  # include ActionPolicy::Controller # includes ActionPolicy authorize methods, needed for API only controllers
  # include ActionPolicy::Behaviour # includes ActionPolicy authorize methods in Service classes
  #
  authorize :user, through: :current_user # makes "user" available to the policy classes
  authorize :team, through: :current_team # makes "team" available to the policy classes
  authorize :member, through: :current_member # makes "member" available to the policy classes

  verify_authorized # ensures all actions are authorized

  before_action :ensure_html_safe_flash

  # dry-validates the dry-contract against the given params
  # which can be either a hash or an ActionController::Parameters object
  #
  def validate_params!(contract, parameters)
    p = parameters.is_a?(ActionController::Parameters) ? parameters.to_unsafe_h : parameters

    ContractValidation.validate!(contract, p)
  end

  # dry-validates the dry-contract implictly against the content of the params' :data key
  # which are expected to adhere to the JSON:API standard https://jsonapi.org/format/#crud-creating
  # ensure the :type is present and matches the given type (throws 400 if not)
  #
  def validate_params_for!(contract, type)
    raise ParamsTypeError.new(key: :type, got: data_params[:type], expected: type) if data_params[:type].to_s != type.to_s

    ContractValidation.validate!(contract, data_params[:attributes])
  end

  # we let Rails / ActionController::StrongParameters ensure that
  # the json request body includes a :data key (and that it is not empty)
  #
  def data_params
    params.require(:data).to_unsafe_h # contains :type and attributes: {...}
  end

  # throwing the error here, after catching it in our routes,
  # means our normal error handler process will be used
  # to log the error and display a message to the user
  def error_404
    raise ActionController::RoutingError.new("Path #{request.path} could not be found")
  end

  private

  # allow to create multiple flashes of the same type in one request
  # def add_flash(type, text, html_safe: false)
  #   flash[:html_safe] = html_safe if html_safe
  #   flash[type] ||= []
  #   flash[type] << text
  # end

  # def error_flash(error, default_message:)
  #   add_flash(:alert, error.message.presence || default_message)
  # end

  def ensure_html_safe_flash
    return unless flash[:html_safe] && flash[:notice]

    flash.delete(:html_safe)

    flash.now[:notice] = if flash[:notice].is_a?(Array)
                           flash[:notice].map(&:html_safe)
                         else
                           flash[:notice].html_safe # rubocop:disable Rails/OutputSafety
                         end
  end

  # to update multiple parts of the page in one request with Turbo and ViewComponents
  # use like this in your controller:
  #
  #   turbo_stream_update("someid", SomeComponent.new(param1: somevalue) )
  #   turbo_stream_update("otherid", OtherComponent.new(other: othervalue) )
  #   render turbo_stream: actions
  #
  # def turbo_stream_update(key, component)
  #   turbo_stream_actions << turbo_stream.update(key, view_context.render(component))
  # end
  #
  # def turbo_stream_actions
  #   @turbo_stream_actions || []
  # end
end
