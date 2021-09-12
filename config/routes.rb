Rails.application.routes.draw do
  devise_for :users, path: 'auth',
             path_names: { sign_in: 'login', sign_out: 'logout', password: 'secret', confirmation: 'verification', unlock: 'unblock', registration: 'register', sign_up: 'sign_up' }

  root to: 'home#index'
  get '/', to: 'home#index', as: :home
  #
  # TODO: Is this used?
  # get 'api-view/meet-event/{meetId}/{eventId?}/{roundId?}/{heatId?}', 'MeetController#viewEvent
  #
  get 'meet-event/:meet_id', to: 'meet#meet'
  get 'meet-event/:meet_id/:event_id(/:round_id)(/:heat_id)', to: 'meet#event' #, constraints: {
  #   meet_id: /\d/,
  #   event_id: /\d/,
  #   round_id: /\d/,
  #   heat_id: /\d/
  # }

  get 'about', to: 'home#about', as: :about
  get 'requirements', to: 'home#requirements', as: :requirements
  get 'contact', to: 'home#contact', as: :contact

  get 'meet/:id', to: 'meet#live', as: :live_meet # , constraints: { id: /\d/ }
  get 'meet/team-standings/:id', to: 'meet#team_standings', as: :team_standings # , constraints: { id: /\d/ }
  get 'meet/pdf/:id', to: 'meet#pdf', as: :meet_pdf # , constraints: { id: /\d/ }

  get 'stadium/:id', to: 'stadium#view', as: :stadium_view # , constraints: { id: /\d/ }
  get 'athlete/:id(/:name)', to: 'athlete#view', as: :athlete_view # , constraints: { id: /\d/ }

  # Dashboard, requires login
  get 'dashboard', to: 'dashboard#index', as: :dashboard
  post 'dashboard/meet/create', to: 'dashboard#create_meet', as: :create_meet

  get 'meet/modify/:id', to: 'dashboard#edit', as: :meet_modify
  post 'meet/modify/:id/edit', to: 'dashboard#actuallyEdit', as: :meet_actually_edit
  post 'meet/points/:id', to: 'dashboard#savePoints', as: :meet_save_points

  get 'meet/run/:id', to: 'dashboard#run', as: :meet_run
  get 'meet/key/:id', to: 'dashboard#downloadKey', as: :meet_key
  post 'meet/preLoad/:id', to: 'dashboard#preLoad', as: :meet_preload

  # Admin, requires login and permission
  #   Route::group(['prefix' => 'admin', 'middleware' => 'auth'], function () {
  #   get 'dashboard', to: 'dashboard#index', as: :backend.dashboard
  #
  #   get 'edit/team', 'AdminController#selectTeamToEdit', as: :admin.edit.team.select
  #   get 'edit/team/:id', 'AdminController#editTeam', as: :admin.edit.team
  #   post 'edit/team/:id', 'AdminController#saveEditTeam', as: :admin.edit.saveTeam
  #
  #   get 'edit/athlete', 'AdminController#selectAthleteToEdit', as: :admin.edit.athlete.select
  #   get 'create/athlete', 'AdminController#createAthlete', as: :admin.create.athlete
  #   get 'edit/athlete/:id', 'AdminController#editAthlete', as: :admin.edit.athlete
  #   post 'edit/athlete/:id', 'AdminController#saveEditAthlete', as: :admin.edit.saveAthlete
  #
  #   get 'edit/stadium', 'AdminController#selectStadiumToEdit', as: :admin.edit.stadium.select
  #   get 'edit/stadium/:id', 'AdminController#editStadium', as: :admin.edit.stadium
  #   post 'edit/stadium/:id', 'AdminController#saveEditStadium', as: :admin.edit.saveStadium
end
