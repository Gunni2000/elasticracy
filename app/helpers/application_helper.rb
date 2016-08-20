module ApplicationHelper 
	def btc_human(satoshies, separator=' ')
		"%.8f#{separator} XEL" % (1.0*satoshies.to_f)
	end

  def percent_human(x)
    if x.present?
      "(%.2f%%)" % (100.0*x)
    else
      ""
    end
  end
end
