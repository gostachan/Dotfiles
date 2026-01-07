# ruby
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export PATH="$HOME/.gem/ruby/4.0.0/bin:$PATH"

# java
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
export CPPFLAGS="-I/opt/homebrew/opt/openjdk@17/include"

# python
export PATH="$HOME/Library/Python/3.9/bin:$PATH"

# stripe
alias stripe_login='stripe login'
alias stripe_listen='stripe listen --forward-to http://127.0.0.1:80/stripe/webhook'
alias stripe_test='stripe trigger payment_intent.succeeded'

