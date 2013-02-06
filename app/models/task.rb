# == Schema Information
#
# Table name: tasks
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  user_id    :integer
#  parent_id  :integer
#  sort_order :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  hidden     :boolean          default(FALSE)
#

class Task < ActiveRecord::Base
  attr_accessible :name, :sort_order, :parent_id

  belongs_to :user
  has_many :tasks, class_name: "Task", foreign_key: "parent_id"

  validates :name, presence: true, length: {maximum: 75}
  validates :parent_id, presence: true
  validates :user_id, presence: true
  validates :sort_order, presence: true

  default_scope order: 'sort_order ASC'
end
