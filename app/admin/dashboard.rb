# frozen_string_literal: true
ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { 'Dashboard' }

  content title: proc { 'Dashboard' } do
    panel "Scraper" do
      para 'Want this: https://co.milesplit.com/meets/458785-liberty-bell-track-and-field-invitational-2022/results/811123'
      para 'URL is required, meet_id is only if you want to append results to the TT meet_id'
      active_admin_form_for 'scrape', title: 'Scraper', url: { action: :scrape, controller: 'scrape' } do |f|
        f.semantic_errors *f.object&.errors&.keys if f.object&.errors

        input :meet_id, as: 'string'
        input :url, as: 'string'

        f.actions
      end
    end
  end
end
