class FlitsController < ApplicationController
	before_filter :login_required

	def create
		flit = current_user.flits.build(params[:flit])
		flit.message = flit.message[0..140] # get 140 characters only
		flit.created_at = Time.now #HACK
		flit.save!
		redirect_to root_path
		#if flit.save!
		#	redirect_to root_path
		#end
		#render :text => flit.inspect

	end

	def destroy
		
	end
end
