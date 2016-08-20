require 'net/http'
class BitcoinAddress < ActiveRecord::Base
  default_scope { order('balance DESC, bitcoin_address ASC') }

  has_many :signatures
  has_many :arguments, through: :signatures

  def request_balance url
    (Integer(Net::HTTP.get(URI.parse(url))) rescue false)
  end

  def update_balance
    res = request_balance("http://localhost:8080/?address=#{self.bitcoin_address}")
  
    if res!=false
      if ( (new_balance=res.to_f) >= 0) and (new_balance != self.balance)
        update_attribute :balance, new_balance
        arguments.each{|a|a.update_validity}
      else
        touch :updated_at # push it to the end of the queue
      end
    else
      log.warn "failed to retrieve XEL balance for bitcoin address #{self.bitcoin_address}"
    end
  end

end
