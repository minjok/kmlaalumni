# encoding: utf-8
class User < ActiveRecord::Base
	
	# *** ATTRIBUTES *** #
	attr_accessible :name, 
					:wave,
					:student_number,
					:email, 
					:password, 
					:password_confirmation, 
					:remember_me


	# *** DEVISE *** #
	devise	:database_authenticatable,
			:registerable,
			:recoverable, 
			:rememberable, 
			:trackable,
            :confirmable
		  # :validatable
		  # :token_authenticatable 
		  # :encryptable
		  # :lockable 
		  # :timeoutable
		  # :omniauthable
		  
		  
	# *** ASSOCIATIONS *** # 
	has_many :groups,      	through: :memberships
	has_many :memberships, 	dependent: :destroy
	
	has_many :schools,		through: :educations
	has_many :educations,	dependent: :destroy
	
	has_many :postings, 	dependent: :destroy
    has_many :comments,     dependent: :destroy
	
	
	# *** VALIDATIONS *** #
	validates_presence_of		:name,
									message: "이름을 입력해주세요"
	
	validates_presence_of		:wave,
									message: "가입 도중 에러가 발생했습니다"
	
	validates_inclusion_of 		:wave, in: 1..(Time.now.year-1998),
									message: "가입 도중 에러가 발생했습니다"
	
	validates_uniqueness_of		:student_number,
									message: "입력하신 학번으로 이미 가입된 동문이 있습니다"

	validates_uniqueness_of		:email, case_sensitive: false,
									message: "이미 사용 중인 이메일입니다"
									
	validates_format_of 		:email, with: /\A[^@]+@[^@]+\z/,
									message: "이메일 형식이 올바르지 않습니다"
									
	validates_presence_of   	:password, on: :create,
									message: "비밀번호를 입력해주세요"
									
	validates_confirmation_of   :password, on: :create,
									message: "비밀번호가 일치하지 않습니다"
									
	validates_length_of 		:password, within: 6..20,
									message: "비밀번호는 6-20자내외로 입력해주세요"
		  
		  
	# *** METHODS *** #
	def is_member_of(group)
	  Membership.exists?(self, group)
	end
	
	def is_admin_of(group)
	  Membership.exists_as_admin?(self, group)
	end
	
	def has_correct_name_and_student_number?
	  not AlumniVerification.where("name = ? AND student_number = ?", self.name, self.student_number).first.blank?
	end
	
	def compute_wave
	  self.wave = (self.student_number[0..1].to_i + 5) % 100
	end
	
end
