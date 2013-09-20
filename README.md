Slog
====

A very simple blog engine. It's designed to be used easily with almost any setup and uses a simple file based system.

Usage
-----

Install markdown gem.
`gem install maruku`

Create a blog directory.
`mkdir blog/default`
or
`mkdir blog/your_name`

Copy slog.rb wherever you want in your application and require it.
`require 'slog'`

###### Initialize Slog

This example will look for a **default** folder in the blog directory.

```ruby
blogs = Slog.new({:markdown => "Maruku",
                  :blog_dir => "#{Dir.pwd}/blog"})
```
This example will look for a **my_name** folder in the blog directory.

```ruby
blogs = Slog.new({:markdown => "Maruku",
                  :blog_dir => "#{Dir.pwd}/blog"},
                  :name => "my_name")
```

###### Get the Blogs

* Get the first blog file.

```ruby
blogs.get(:first)
```

* Get the last blog file.

```ruby
blogs.get(:last)
```

* Get the first 20 blog files

```ruby
blogs.get(:first, 20)
```

* Get the last 20 blog files

```ruby
blogs.get(:last, 20)
```

###### Process the Blogs

Calling **process** processes all of your .txt files and populates the **processed_data** attribute with
either and array of hashes or just one hash depending on whether **get** was passed a second parameter greater than
1.

```ruby
blogs.process
```

###### Text Files

Text files should be formatted like this `year-month-day__blog_name.txt`.

`2013-9-16__test_blog.txt`

ERB is used to add and pull data from the .txt files. In order to have a title and tags
you must set `data[:title]` and `data[:tags]`. Any information passed to the **data** hash will end up in the
**processed_data** hash for that file.
```erb
<%data[:title] = "Test Blog" %>
<%data[:tags] = ["test", "blog"]%>

## <%= data[:title] %> ##

```
###### Processed Data

'blogs.processed_data' should return either an array of hashes or a hash.

```ruby
[{:title=>"", 
  :tags=>"", 
  :html=>"", 
  :date=>#<Date: 2013-09-14 (4913099/2,0,2299161)>, 
  :name=>"test2"}, 
 {:title=>"Test Blog", 
  :tags=>["test", "blog"], 
  :html=>"<h2 id='test_blog'>Test Blog</h2>", 
  :date=>#<Date: 2013-09-15 (4913101/2,0,2299161)>, 
  :name=>"test_blog"}]
```

or

```ruby
{:title=>"Test Blog", 
 :tags=>["test", "blog"], 
 :html=>"<h2 id='test_blog'>Test Blog</h2>", 
 :date=>#<Date: 2013-09-15 (4913101/2,0,2299161)>, 
 :name=>"test_blog."}
```
