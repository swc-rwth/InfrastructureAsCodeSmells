# InfrastructureAsCodeSmells
Smells and Anti-Patterns for InfructureAsCode

# Content
Foodcritic rules for code smell detection of code smells described in corresponding paper using the Foodcritic rule DSL.

## rules
Due to a bug in the foodcritic API, rules with the recipe block, do not only scan Recipes, but also a bunch of other files. This is by now intended by foodcritic and will not getting fixed, because many peoply rely on the recipe block pulling in all kind of other files. For this reason, we use for those rules which are exclusively for Recipes, the cookbook block and manually scan the Recipes, respectively the attributes. We consider this as the current ruleset and ALL rules are in the rules folder.

## rules-deprecated
This folder still contains the deprecated rules, which scan all kind of files, not only Recipes. This might be useful in some cases. There is no guarantee, that the rules are otherwise equal to those in the rules folder, since the rule folder is mainly updated.

# INSTALLATION
* install RVM (https://rvm.io/rvm/install)
* rvm install ruby-2.4.0
* navigate to dir of Gemfile of this repo
* gem install foodcritic
* gem install bundler
* bundle install
* --> foodcritic + dependencies should be installed


# USAGE
* bash -l   #login shell for rvm
* rvm use ruby-2.4.0
* foodcritic -B /pathtocookbook/ -I /pathtocloneddir/foodcritic_rules/rules/
