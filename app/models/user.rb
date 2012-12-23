# encoding: utf-8
class User < ActiveRecord::Base
	
	# *** ATTRIBUTES *** #
	attr_accessible :name, 
					:wave,
					:student_number,
					:email, 
					:password, 
					:password_confirmation,
                    :current_password,
					:remember_me
                    
    attr_accessor   :current_password
    

	# *** DEVISE *** #
	devise	:database_authenticatable,
			:registerable,
			:recoverable, 
			:rememberable, 
			:trackable
          # :confirmable
		  # :validatable
		  # :token_authenticatable 
		  # :encryptable
		  # :lockable 
		  # :timeoutable
		  # :omniauthable
		  
		  
	# *** ASSOCIATIONS *** # 
	has_many :groups, through: :memberships
	has_many :memberships, dependent: :destroy
	
	has_many :schools, through: :educations
	has_many :educations, dependent: :destroy
	
    has_many :organizations, through: :employments
	has_many :employments, dependent: :destroy
    
	has_many :postings, dependent: :destroy
    has_many :comments, dependent: :destroy
    has_many :likes,    dependent: :destroy
	
	
	# *** VALIDATIONS *** #
	validates_presence_of		:name,
									message: "이름을 입력해주세요"
	
	validates_presence_of		:wave,
									message: "가입 도중 에러가 발생했습니다"
	
	validates_inclusion_of 		:wave, in: 1..(Time.now.year-1998),
									message: "가입 도중 에러가 발생했습니다"
	
	validates_uniqueness_of		:student_number,
									message: "입력하신 학번으로 이미 가입된 동문이 있습니다"
                                   
	validates_presence_of       :email,
                                    message: "이메일을 입력해주세요"
    
    validates_uniqueness_of		:email,
									message: "이미 사용 중인 이메일입니다"
									
	validates_format_of 		:email, with: /\A[^@]+@[^@]+\z/,
									message: "올바른 이메일 형식이 아닙니다"
									
	validates_presence_of   	:password, if: :password_required?,
									message: "비밀번호를 입력해주세요"
									
	validates_confirmation_of   :password, if: :password_required?,
									message: "비밀번호가 일치하지 않습니다"
									
	validates_length_of 		:password, within: 6..20, if: :password_required?,
									message: "비밀번호는 6-20자내외로 입력해주세요"
		  
		  
	# *** METHODS *** #
	def after_active_sign_in_path_for(resource)
      respond_to root_path
    end
    
    def after_inactive_sign_up_path_for(resource)
      respond_to root_path
    end
    
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
    
    def update_with_password(params, *options)
     current_password = params.delete(:current_password)

     result = if valid_password?(current_password)
       update_attributes(params, *options)
     else
       params.delete(:password)
       self.assign_attributes(params, *options)
       self.valid?
       self.errors.add(:current_password, current_password.blank? ? '현재 비밀번호를 입력해주세요' : '현재 비밀번호를 올바르게 입력해주세요')
       false
     end

     result
    end
    
    def wrote?(content)
      content.user === self
    end
    
    def likes?(platform_id, platform)
      Like.exists?(self.id, platform_id, platform)
    end
    
	protected
      def password_required?
        !persisted? || !password.nil? || !password_confirmation.nil?
      end
end
