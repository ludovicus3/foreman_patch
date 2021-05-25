Foreman::Application.routes.draw do
  mount ForemanPatch::Engine, at: '/', as: 'foreman_patch'
end
