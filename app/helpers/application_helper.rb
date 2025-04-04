module ApplicationHelper
  def tw_merge(*class_list)
    TailwindMerge::Merger.new.merge(class_names(class_list))
  end
end
