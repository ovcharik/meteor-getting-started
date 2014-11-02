# client/config/router.coffee
Router.configure
  layoutTemplate: 'application'
  loadingTemplate: 'loading'

# Session.set('loading', false)
# setTimeout (-> Session.set('loading', true)), 500
# artificialTimeout = -> Session.get('loading')

# Router.waitOn ->
#   artificialTimeout
