#Ruby + JSON RESTful API: приложение с объявлениями о работе#

https://github.com/aristofun/webdevdao/blob/master/test_assignments/job_advertisement_site.md

docker compose up - запуск приложения  
docker compose run web bin/rails test - запуск тестов  

Эндпоинты:  
Создание пользователя - POST localhost:3000/users  
Создание объявления - POST localhost:3000/announcements  
Пользователь окликается на объявление - POST localhost:3000/announcements/:announcement_id/responses  
Автор объявления отменяет объявление - POST localhost:3000/announcements/:announcement_id/cancel  
Автор объявления принимает отклик - POST localhost:3000/announcements/:announcement_id/responses/:response_id/accept  
Автор отклика отменяет отклик - POST localhost:3000/announcements/:announcement_id/responses/:response_id/cancel  
Получение своего объявления - GET localhost:3000/announcements/my  
Получение всех активных объявлений - GET localhost:3000/announcements/active  