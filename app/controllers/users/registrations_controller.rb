class Users::RegistrationsController < Devise::RegistrationsController
	
	def create
		build_resource
		resource.process_student_number
	
		if resource.errors.empty? && resource.save
			sign_in(resource_name, resource)
			respond_with resource, :location => after_sign_up_path_for(resource)
		else
			clean_up_passwords resource
			respond_with resource
		end

	end
	
end
