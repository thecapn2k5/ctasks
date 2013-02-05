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

require 'spec_helper'

describe Task do
  pending "add some examples to (or delete) #{__FILE__}"
end
