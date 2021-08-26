Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'
  get '/', to: 'home#index', as: :home

  get 'upcoming-meets', to: 'meet#upcoming_meets', as: :upcoming_meets
  get 'current-meets', to: 'meet#current_meets', as: :current_meets
  #
  # TODO: Is this used?
  # Route::get('api-view/meet-event/{meetId}/{eventId?}/{roundId?}/{heatId?}', 'MeetController@viewEvent')
  #
  get 'meet-event/:meet_id', to: 'meet#meet'
  get 'meet-event/:meet_id/:event_id(/:round_id)(/:heat_id)', to: 'meet#event', constraints: {
    meet_id: /\d/,
    event_id: /\d/,
    round_id: /\d/,
    heat_id: /\d/
  }

  get 'about', to: 'home#about', as: :about
  get 'requirements', to: 'home#requirements', as: :requirements
  get 'contact', to: 'home#contact', as: :contact

  get 'meet/:id', to: 'meet#live', as: :live_meet, constraints: { id: /\d/ }
  get 'meet/team-standings/:id', to: 'meet#team_standings', as: :team_standings, constraints: { id: /\d/ }
  get 'meet/pdf/:id', to: 'meet#pdf', as: :meet_pdf, constraints: { id: /\d/ }

  get 'stadium/:id', to: 'stadium#view', as: :stadium_view, constraints: { id: /\d/ }
  get 'athlete/:id(/:name)', to: 'athlete#view', as: :athlete_view, constraints: { id: /\d/ }


  # Route::group(['middleware' => 'auth'], function ()
  # {
  #   Route::get('dashboard', 'DashboardController@index')->name('frontend.dashboard')
  #
  # Route::get('meet/create/new', 'MeetController@create')->name('frontend.meet.create')
  # Route::post('meet/create/action', 'MeetController@actuallyCreate')->name('frontend.meet.actuallyCreate')
  #
  # Route::get('meet/modify/{id}', 'MeetController@edit')->name('frontend.meet.modify')
  # Route::post('meet/modify/{id}/edit', 'MeetController@actuallyEdit')->name('frontend.meet.actuallyEdit')
  # Route::post('meet/points/{id}', 'MeetController@savePoints')->name('frontend.meet.savePoints')
  #
  # Route::get('meet/run/{id}', 'MeetController@run')->name('frontend.meet.run')
  # Route::get('meet/key/{id}', 'MeetController@downloadKey')->name('frontend.meet.key')
  # Route::post('meet/preLoad/{id}', 'MeetController@preLoad')->name('frontend.meet.preLoad')
  #
  # Route::get('logout', 'Frontend\Auth\AuthController@getLogout')
  # })
  #
  #
  # Route::group(['prefix' => 'admin', 'middleware' => 'auth'], function () {
  #   Route::get('dashboard', 'DashboardController@index')->name('backend.dashboard')
  #
  #   Route::get('edit/team', 'AdminController@selectTeamToEdit')->name('admin.edit.team.select')
  #   Route::get('edit/team/{id}', 'AdminController@editTeam')->name('admin.edit.team')
  #   Route::post('edit/team/{id}', 'AdminController@saveEditTeam')->name('admin.edit.saveTeam')
  #
  #   Route::get('edit/athlete', 'AdminController@selectAthleteToEdit')->name('admin.edit.athlete.select')
  #   Route::get('create/athlete', 'AdminController@createAthlete')->name('admin.create.athlete')
  #   Route::get('edit/athlete/{id}', 'AdminController@editAthlete')->name('admin.edit.athlete')
  #   Route::post('edit/athlete/{id}', 'AdminController@saveEditAthlete')->name('admin.edit.saveAthlete')
  #
  #   Route::get('edit/stadium', 'AdminController@selectStadiumToEdit')->name('admin.edit.stadium.select')
  #   Route::get('edit/stadium/{id}', 'AdminController@editStadium')->name('admin.edit.stadium')
  #   Route::post('edit/stadium/{id}', 'AdminController@saveEditStadium')->name('admin.edit.saveStadium')
  # })
end
