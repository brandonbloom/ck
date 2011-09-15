ck = require './lib/ck'
coffeekup = require 'coffeekup'
jade = require 'jade'
eco = require 'eco'

template = ->
  doctype 5
  html ->
    head ->
      title @title
    body ->
      div id: 'content', ->
        for post in @posts
          div class: 'post', ->
            p post.name
            div post.comment
      form method: 'post', ->
        ul ->
          li -> input name: 'name'
          li -> textarea name: 'comment'
          li -> input type: 'submit'

jadeString = '''
!!! 5
html
  head
    title= title
  body
    #content
      - for post in posts
        .post
          p= post.name
          div= post.comment
    form(method='post')
      ul
        li
          input(name='name')
        li
          textarea(name='comment')
        li
          input(type='submit')
'''

ecoString = '''
<!DOCTYPE html>
<html>
  <head>
    <title><%= @title %></title>
  </head>
  <body>
    <div id="content">
      <% for post in @posts: %>
        <div class="post">
          <p><%= post.name %></p>
          <div><%= post.content %></div>
        </div>
      <% end %>
    </div>
    <form method="post">
      <ul>
        <li><input name="name"></li>
        <li><textarea name="comment"></textarea></li>
        <li><input type="submit"></li>
      </ul>
    </form>
  </body>
</html>
'''

context =
  title: 'my first website!'
  posts: [
    name: 'my first post'
    content: 'it is about stuff.'
  ]

ck_template = ck.compile template
coffeekup_template = coffeekup.compile template
jade_template = jade.compile(jadeString)

benchmark = (name, fn) ->
  start = new Date
  for i in [0..10000]
    fn()
  end = new Date
  console.log "#{name}: #{end - start}ms"

exports =
  benchmark 'ck', -> ck_template context: context
  benchmark 'ck (format)', -> ck_template context: context, format: true
  benchmark 'coffeekup', -> coffeekup_template context: context
  benchmark 'coffeekup (format)', -> coffeekup_template context: context, format: true
  benchmark 'jade', -> jade_template context
  benchmark 'eco', -> eco.render ecoString, context
