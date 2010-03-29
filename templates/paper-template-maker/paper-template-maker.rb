#!/usr/bin/env ruby

require 'fileutils'

def usage
  message =<<-EOF
usage:  paper-template-maker.rb papername

Synopsis:

  generate a standard directory template for a scientific publication

Options:

  "papername" specifies the identifier for the paper. The following naming convention is recommended:
  plessl10_fpl -> First author name: Plessl, year 2010, paper to be published at FPL conference

Authors:
  Christian Plessl <christian@plesslweb.ch>

EOF
  puts "#{message}"
  exit
end

def makefile_template(papername)
  makefile=<<-EOF
LATEX=pdflatex
LATEXMK=latexmk
LATEXOPT=-file-line-error


MAIN=%%PAPERNAME%%

BIBFILES := $(shell ls bib/*.bib)
FIGURES := $(shell ls fig/*.pdf)
SOURCES=$(MAIN).tex Makefile $(BIBFILES)

all:    $(MAIN).pdf

.refresh:
        touch .refresh

$(MAIN).pdf: $(MAIN).tex .refresh $(SOURCES) $(FIGURES)
        $(LATEXMK) -pdf $(MAIN).tex

force:
        touch .refresh
        $(MAKE) $(MAIN).pdf

.PHONY: clean force all

clean:
        $(LATEXMK) -C $(MAIN).tex
        rm -f $(MAIN).pdfsync
        rm -rf *~ *.tmp
  EOF
  makefile.gsub!("%%PAPERNAME%%",papername)
  puts makefile
end


puts "ARGC #{ARGV.length}\n"

if ARGV.length != 1 then
  usage()
end

papername = ARGV[0]

puts "generating template for paper: #{papername}"

Dir.mkdir("#{papername}")
Dir.mkdir("#{papername}/trunk")
Dir.mkdir("#{papername}/trunk/bib")
Dir.mkdir("#{papername}/trunk/data")
Dir.mkdir("#{papername}/trunk/fig")
Dir.mkdir("#{papername}/tags")
FileUtils.touch("#{papername}/#{papername}.bib")  # TODO insert template to file
FileUtils.touch("#{papername}/#{papername}.pdf")

# TODO Add Makefile Template
makefile_template(papername)
