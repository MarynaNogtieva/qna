class Attachment < ApplicationRecord
  mount_uploaders :files, FileUploader
  belongs_to :attachable, polymorphic: true, optional: true
end
