class SignatureValidator < ActiveModel::Validator
  def validate(sig)
  	if BitcoinAddress.find_by_bitcoin_address(sig.signature_address)

  	else
  		if sig.signature_address == false
  			sig.errors[:base] << "Invalid signature! Please use Bitcoin software to sign the message."
  		else
      		sig.errors[:base] << "Signature not accepted. Either it is invalid or your Bitcoin address (#{sig.signature_address}) was not used for any donation."
      	end
  	end
  end
end
