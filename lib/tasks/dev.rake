namespace :dev do

  desc "Task que roda todas tasks"
  task setup: :environment do

    images_path = Rails.root.join('public', 'system')

    puts "Apagando public/system #{%x(rm -rf #{images_path})}" #rm=remove rf=remove de qlq forma
    puts %x(rails db:drop)
    puts %x(rails db:create)
    puts %x(rails db:migrate)
    puts %x(rails db:seed)
    puts %x(rails dev:generate_users)
    puts %x(rails dev:generate_teams)
    puts %x(rails dev:generate_team_user)
    puts %x(rails dev:generate_sprints)
    puts %x(rails dev:generate_projects)
    puts %x(rails dev:generate_project_sprints)
    puts %x(rails dev:generate_weeks)
    puts %x(rails dev:generate_colors)
    puts %x(rails dev:generate_labels)
    puts %x(rails dev:generate_statuses)
    puts %x(rails dev:generate_activities)
    puts %x(rails dev:generate_macro_activities)
    puts %x(rails dev:generate_progresses)
    puts %x(rails dev:generate_hours_registries)

  end
#---------------------------------------------------#

  desc "Cadastra os usuários"
  task generate_users: :environment do

    puts "Gerando USUÁRIOS FAKES..."

    10.times do
      user = User.create!(
              email: Faker::Internet.email,
              password: 123456,
              password_confirmation: 123456
              )

      UserProfile.create!(
        name: Faker::Name.name,
        student_number: Faker::Number.number(10),
        user_id: user.id,
        role: Random.rand(0..1)#sorteia se o usuario é admin ou nao
        )
    end

    puts "Gerando USUÁRIOS FAKES... [OK]"
  end
#---------------------------------------------------#

  task generate_teams: :environment do

  puts "Gerando EQUIPES FAKES..."

  @teams_name = teams_name

  @teams_name.each do |name|
    Team.create!(
      description: name
    )
  end

  puts "Gerando EQUIPES FAKES... [OK]"
end
#---------------------------------------------------#
  task generate_team_user: :environment do

    puts "Gerando a relação entre USÁRIOS e EQUIPES..."

    Team.all.each do |team|
      10.times do
        TeamUser.create!(
          team_id: team.id,
          user_id: User.all.sample.id
          )
      end
    end

    puts "Gerando a relação entre USÁRIOS e EQUIPES... [OK]"
  end
#---------------------------------------------------#
  task generate_sprints: :environment do

    puts "Gerando os SPRINTS..."

    sprints = [['Sprint 5', '16.2'], ['Sprint 1', '17.1'], ['Sprint 2', '17.1'],
               ['Sprint 3', '17.1'], ['Sprint 4', '17.1'], ['Sprint 5', '17.1']]

    inicio = Date.new(2016, 12, 01)

    sprints.each do |s_name, s_semester|
      Sprint.create!(
        description: s_name,
        semester: s_semester,
        # Gerar datas aleatorias entre 1 meês atrás (a partir de ontem)
        # e 3 meses atrás (a partir de ontem)
        inicio: inicio,
        # Gerar datas aleatorias entre 1 meses atrás (a partir de ontem) e
        # ontem
        fim: inicio + 5.weeks - 1.day
        )
      inicio = inicio + 5.weeks
    end

    puts "Gerando os SPRINTS... [OK]"
  end
#---------------------------------------------------#

  task generate_projects: :environment do

    puts "Gerando os PROJETOS..."

    projects = ['Projeto 1', 'Projeto 2', 'Projeto 3', 'Projeto 4']
    Team.all.each do |team|
      project = projects.sample
      Project.create!(
        description: project,
        team_id: team.id
        )
      projects.delete(project)
    end

    puts "Gerando os PROJETOS... [OK]"
  end
#---------------------------------------------------#

  task generate_project_sprints: :environment do

    puts "Gerando a relação entre PROJETOS e SPRINTS..."

    Project.all.each do |project|
      4.times do
        ProjectSprint.create!(
          project_id: project.id,
          sprint_id: Sprint.all.sample.id
          )
      end
    end

    puts "Gerando a relação entre PROJETOS e SPRINTS... [OK]"
  end
#---------------------------------------------------#

  task generate_weeks: :environment do

    puts "Gerando as SEMANAS..."

    Sprint.all.each do |s|
      start_s = s.inicio
      end_s = s.fim

      while(start_s < end_s)
        difference = start_s.wday == 1 ? 5 : 1.week - 1
        Week.create(
          description: Week.last.present? ?
                       "Semana #{Week.where(sprint_id: s.id).count + 1}" : "Semana 1",
          start_w: start_s,
          end_w: start_s + difference,
          expected_hours: 15,
          sprint_id: s.id
          )
        start_s += 1.week
      end
    end

    puts "Gerando as SEMANAS... [OK]"
  end
#---------------------------------------------------#

  task generate_colors: :environment do

    puts "Gerando as CORES..."

    colors = colors_name
    colors.each do |color|
      Color.create!(
        description: color
      )
    end

    puts "Gerando as CORES... [OK]"
  end
#---------------------------------------------------#

  task generate_labels: :environment do

    puts "Gerando os RÓTULOS..."

    labels = labels_name

    labels.each do |name, color|
      Label.create!(
        description: name,
        color_id: Color.where(description: color).first.id
      )
    end

    puts "Gerando os RÓTULOS... [OK]"
  end
#---------------------------------------------------#

  task generate_statuses: :environment do

    puts "Gerando os STATUS..."

    status_color = status_name_color

    status_color.each do |status, color|
      Status.create!(
        description: status,
        color_id: Color.where(description: color).first.id
      )
    end

    puts "Gerando os STATUS... [OK]"
  end
#---------------------------------------------------#

  task generate_activities: :environment do

    puts "Gerando as ATIVIDADES..."

    Project.all.each do |project|
      project.team.users.each do |user|
        project.sprints.each do |sprint|

          number = Random.rand(1..25) # 6

          Activity.create!(
            description: LeroleroGenerator.sentence,
            pontos_cadastrados: number, # 6
            pontos_atualizados: Random.rand(1..number), # 1-6
            status_id: Status.all.sample.id,
            label_id: Label.all.sample.id,
            project_id: project.id,
            sprint_id: sprint.id,
            user_id: user.id
            )

        end
      end
    end

    puts "Gerando as ATIVIDADES... [OK]"
  end
#---------------------------------------------------#

  task generate_macro_activities: :environment do

    puts "Gerando as MACRO ATIVIDADES..."

    macro_atv = macro_activities_names

    macro_atv.each do |ma|
      Project.all.each do |project|
        MacroActivity.create(
          description: ma,
          completeness: Random.rand(0..100), # Completude atual da MA
          project_id: project.id
          )
      end
    end

    puts "Gerando as MACRO ATIVIDADES... [OK]"
  end
#---------------------------------------------------#

  task generate_progresses: :environment do

    puts "Gerando os PROGRESSOS dos PROJETOS..."

    Project.all.each do |p|

      # Descrobrir a média de completude das macro atividades de cada projeto
      ma_avg = 0
      p.macro_activities.each do |ma|
        ma_avg += ma.completeness.to_f
      end
      ma_avg = ma_avg / p.macro_activities.count.to_f

      p.sprints.each do |s|
        if s.id == p.sprints.last.id
          Progress.create!(
            completeness: ma_avg.round(2),
            advance: p.progresses.last.present? ?
                     "#{(ma_avg.round(2) - p.progresses.last.completeness.to_f).round(2)}" :
                     ma_avg.round(2),
            project_id: p.id,
            sprint_id: s.id
            )
        else
          number = Random.rand(1..ma_avg).round(2)
          Progress.create!(
            completeness: number,
            advance: p.progresses.last.present? ?
                     "#{(number - p.progresses.last.completeness.to_f).round(2)}" :
                     number,
            project_id: p.id,
            sprint_id: s.id
            )
        end
      end

    end

    puts "Gerando os PROGRESSOS dos PROJETOS... [OK]"
  end
#---------------------------------------------------#

  task generate_hours_registries: :environment do

    puts "Gerando os REGISTROS de HORAS..."

    Team.all.each do |t|
      t.users.each do |u|
        t.project.sprints.each do |s|
          s.weeks.each do |w|

            hour_start = Time.zone.now
            hour_end = Random.rand((hour_start + 1)..(hour_start + (w.expected_hours).to_i.hour))

            HoursRegistry.create!(
              start_hr: hour_start,
              end_hr: hour_end,
              hours_performed: hour_end - hour_start,
              week_id: w.id,
              user_id: u.id,
              project_id: t.project.id
              )

          end
        end
      end
    end

    puts "Gerando os REGISTROS de HORAS... [OK]"
  end
#---------------------------------------------------#

  private
  def teams_name
    names = ['Azul', 'Vermelho', 'Amarelo', 'Preto']
  end

  def colors_name
    colors = ["#ff5e00", "#7a00cc", "#7d0746", "#b3cf00", "#04b81c", "#171061",
              "#b05500", "#ff0000","#7c8f00","#065e00", "#0009ff", "#616161"]
  end

  def status_name_color
    status_color = [["Não iniciada", "#7c8f00"],
                    ["Em andamento", "#065e00"],
                    ["Validado", "#0009ff"],
                    ["Aguardando validação", "#616161"]]
  end

  def labels_name
    labels = [["Bug","#ff0000"],["Cancelado","#b05500"],
              ["Documentação","#0009ff"],["Funcionalidade","#171061"],
              ["Melhoria","#04b81c"],["Operacional","#b3cf00"],
              ["Pendente","#7d0746"],["Pesquisa","#7a00cc"],
              ["Teste","#ff5e00"]]
  end

  def macro_activities_names
    man = ["Macro Atv. 1", "Macro Atv. 2", "Macro Atv. 3",
           "Macro Atv. 4", "Macro Atv. 5"]
  end

end
