#!/usr/bin/env ruby

require 'octokit'
require 'csv'

client = Octokit::Client.new(access_token: ENV['TOKEN'], per_page: 100)

client.auto_paginate = true

issues = client.issues("your_github_repository/#{ENV['PROJECT']}", labels: ENV['LABEL'], state: 'all')

issues_without_prs = issues.reject(&:pull_request)


CSV.open('tcc.csv', 'w') do |file|

  file << %w(Nome Data Labels Link)
  issues_without_prs.each do |issue|
    file << [
      issue.title,
      issue.created_at,
      issue.labels.map(&:name).join(', '),
      issue.html_url
    ]
  end
end