# encoding: utf-8
class User < ActiveRecord::Base
	
	#	*** ATTRIBUTES ***	#
	attr_accessible :name, 
					:wave,
					:student_number,
					:email, 
					:password, 
					:password_confirmation, 
					:remember_me


	#	*** DEVISE ***	#
	devise	:database_authenticatable,
			:registerable,
			:recoverable, 
			:rememberable, 
			:trackable
		  # :token_authenticatable 
		  # :encryptable
	      # :confirmable 
		  # :lockable 
		  # :timeoutable
		  # :omniauthable
		  
		  
	#	*** VALIDATIONS ***	#
	validates_presence_of		:name,
									message: "이름을 입력해주세요"
	
	validates_presence_of		:wave,
									message: "가입 도중 에러가 발생했습니다"
	
	validates_inclusion_of 		:wave, in: 1..(Time.now.year-1995),
									message: "가입 도중 에러가 발생했습니다"
	
	validates_uniqueness_of		:student_number,
									message: "입력하신 학번으로 이미 가입된 동문이 있습니다"

	validates_uniqueness_of		:email, case_sensitive: false, allow_blank: true, if: :email_changed? ,
									message: "이미 사용 중인 이메일입니다"
									
	validates_format_of 		:email, with: /\A[^@]+@[^@]+\z/, allow_blank: true, if: :email_changed? ,
									message: "이메일 형식이 올바르지 않습니다"
									
	validates_presence_of   	:password, on: :create,
									message: "비밀번호를 입력해주세요"
									
	validates_confirmation_of   :password, on: :create,
									message: "비밀번호가 일치하지 않습니다"
									
	validates_length_of 		:password, within: 6..20, allow_blank: true,
									message: "비밀번호는 6-20자내외로 입력해주세요"
		  
		  
	# *** METHODS *** #
	def process_student_number
		alumniVerification = AlumniVerification.where("name = :name AND student_number = :student_number",
														:name => self.name, :student_number => self.student_number).first
		if alumniVerification.nil?
			self.errors.add(:student_number, "동문 확인에 실패했습니다. 이름과 학번을 다시 확인해주세요")
		else
			self.wave = (self.student_number[0..1].to_i + 5) % 100
		end
	end
	
end
