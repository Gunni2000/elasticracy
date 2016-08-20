class SignaturesController < ApplicationController
  respond_to :html, :js

  def create
    @argument = Argument.find(params[:argument_id])
    if @argument.topic.due < DateTime.now
      logger.error "Expired"
    else
      @signature = Signature.new({argument_id: @argument.id, signature: signature_params["signature"], negation: signature_params["negation"]})
      @signature.create_bitcoin_address_if_needed

      respond_to do |format|
        begin
          if @signature.save
            @argument.update_validity
            # redirect_to [@argument], notice: "Your vote of #{@signature.bitcoin_address.balance} is accepted"
            # format.html { redirect_to [@argument, @signature], notice: 'Signature was successfully created.' }
            flash[:notice] = "Your vote of #{@signature.bitcoin_address.balance} XEL is accepted!"
            flash.keep(:notice)
            url = argument_url(@argument.id)
            format.js   { render :create, :locals => {redirection_url: url, exception: nil} }
            # format.json { render :show, status: :created, location: @signature }
          else
            # format.html { render :new }
            error_message = @signature.errors.full_messages.join('; ')
            format.js   { render :create_fail, :locals => {error_message:  error_message, exception: nil} }
            # format.json { render json: @signature.errors, status: :unprocessable_entity }
          end
        rescue => e
         logger.error e.message
         e.backtrace.each { |line| logger.error line }
         format.js {render :create_fail, :locals => {error_message: "Signature submission failed (non-unique signature?)" , exception: e}}
        end    
      end
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def signature_params
      params[:signature]
    end
end
