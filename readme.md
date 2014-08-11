# Page Resources Engine for Refinery CMS

## About

Page Resources allows you to relate one or more resources to any page in Refinery which makes it really easy for you to create simple resource galleries with lightbox style popups on the front end page views.

## Requirements

* refinerycms >= 2.1.0

## Features

* Ability to select one or more resources from the resource picker and assign them to a page
* An resource can be assigned to more than one page
* Reordering support, simply drag into order
* An resource assigned to a page can have a caption.
* An resource's caption can be different for different pages

## Install

Add this line to your applications `Gemfile`

```ruby
gem 'refinerycms-page-resources', '~> 2.1.0'
```

Next run

```bash
bundle install
rails generate refinery:page_resources
rake db:migrate
```

Now when you start up your Refinery application, edit a page and there should be a new "Resources" tab.

# Deploying to Heroku

In order to properly precompile assets on Heroku, config vars must be present in the environment during slug compilation.

```bash
heroku labs:enable user-env-compile -a myapp
```

otherwise you may experience the following error:
```
could not connect to server: Connection refused
Is the server running on host "127.0.0.1" and accepting
TCP/IP connections on port 5432?
```


[More Details](https://devcenter.heroku.com/articles/labs-user-env-compile)

## Enable Captions

You can enable captions using an initializer containing the following configuration:

```ruby
# app/config/initializers/refinery/page-resources.rb
Refinery::PageResources.captions = true
```

By default, captions are WYM editors. Prefer `textarea`s? Gotcha :

```ruby
Refinery::PageResources.wysiwyg = false
```

## Usage

`app/views/refinery/pages/show.html.erb`

If you don't have this file then Refinery will be using its default. You can override this with

```bash
rake refinery:override view=refinery/pages/show
```

If resources have been assigned to a page several objects are available for showing on the page. They are

* `@page.resources`: A collection of resources assigned to the page.
* `@page.caption_for_resource_index(i)` will return the caption (if any) for the i<sup>th</sup> resource in @page.resources
* `@page.resources_with_captions`: A collection of resource_with_caption objects with the attributes resource: and caption:

```erb
<% content_for :body_content_right do %>
  <ul id='gallery'>
    <% @page.resources.each do |resource| %>
      <li>
        <%= link_to resource_tag(resource.thumbnail(geometry: "200x200#c").url),
                    resource.thumbnail(geometry: "900x600").url %>
      </li>
   <% end %>
  </ul>
<% end %>
<%= render :partial => "/refinery/content_page" %>
```

If you have enabled captions, you can show them like this

```erb
<% content_for :body_content_right do %>
  <ul id='gallery'>
    <% @page.resources.each_with_index do |resource, index| %>
      <li>
        <%= link_to resource_tag(resource.thumbnail(geometry: "200x200#c").url),
                    resource.thumbnail(geometry: "900x600").url %>
        <span class='caption'><%=raw @page.caption_for_resource_index(index) %></span>
      </li>
   <% end %>
  </ul>
<% end %>
<%= render :partial => "/refinery/content_page" %>
```
or like this
```erb
<% content_for :body_content_right do %>
  <section id='gallery'>
    <% @page.resources_with_captions do |iwc| %>
      <figure>
        <%= link_to resource_tag(iwc.resource.thumbnail(geometry: "200x200#c").url),
                    iwc.resource.thumbnail(geometry: "900x600").url %>
        <figcaption><%=raw iwc.caption %></figcaption>
      </figure>
   <% end %>
  </section>
<% end %>
<%= render :partial => "/refinery/content_page" %>
```
## Screenshot

![Refinery CMS Page Resources Screenshot](http://refinerycms.com/system/resources/0000/1736/refinerycms-page-resources.png)
