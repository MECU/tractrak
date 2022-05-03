# frozen_string_literal: true
ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { 'Dashboard' }

  content title: proc { 'Dashboard' } do
    panel "Scraper" do
      para 'Want this: https://co.milesplit.com/meets/458785-liberty-bell-track-and-field-invitational-2022/results/811123'
      active_admin_form_for 'scrape', title: 'Scraper', url: { action: :scrape, controller: 'scrape' } do |f|
        f.semantic_errors *f.object&.errors&.keys if f.object&.errors

        input :url, as: 'string'

        f.actions
      end
    end
  end
end
