# client/routes/users.coffee
Router.route '/users', name: 'users'
class @UsersController extends PagableRouteController

  # количество пользователей на одной странице
  perPage: 20

  # подписываемся на коллекцию пользователей, с заданными лимитом,
  # чтобы не получать лишние данные
  # 
  # подписка происходит через данный метод, чтобы iron:router
  # не рендерил шаблон загрузки страницы, каждый раз при обновлении
  # подписки
  subscriptions: ->
    @subscribe 'users', @limit()

  # возвращаем всех пользователей из локальной коллекции
  data: ->
    users: UsersCollection.find()

  # все ли пользователи загружены?
  loaded: ->
    @limit() > UsersCollection.find().count()

  # сбрасываем каждый раз лимит, при загрузки страницы
  onRun: ->
    @resetLimit()
    @next()
