object @round

attribute :id

node :complete do
  @round.finished?
end

node :progress do
  @round.progress_report
end
