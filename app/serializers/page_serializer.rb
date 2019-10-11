class PageSerializer < ActiveModel::Serializer
  attributes :title, :link, :relevance
end