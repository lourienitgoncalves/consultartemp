      $set sourceformat"free"

      *>Divisão de identificação do programa
       identification division.
       program-id. "lista11ex1v2".
       author. "Lourieni Gonçalves"
       installation. "PC".
       date-written. 24/07/2020.
       date-compiled. 24/07/2020.


      *>Divisão para configuração do ambiente
       environment division.
       configuration section.
           special-names. decimal-point is comma.

      *>-----Declaração dos recursos externos
       input-output section.
       file-control.

      *>   Declaração do arquivo
           select arqTemperaturas assign to "arqTemperaturas.txt"
           organization is line sequential
           access mode is sequential
           lock mode is automatic
           file status is ws-fs-arqTemperaturas.

       i-o-control.

      *>Declaração de variáveis
       data division.

      *>----Variaveis de arquivos
      *>----Variaveis de arquivos
       file section.
       fd arqTemperaturas.
       01  fd-temperaturas.
           05 fd-temp                              pic s9(02)v99.



      *>----Variaveis de trabalho
       working-storage section.
       01 ws-fs-arqTemperaturas                    pic  9(02).

       01 ws-temperaturas occurs 30.
          05 ws-temp                               pic s9(02)v99 value 0.

       77 ws-media-temp                            pic s9(02)v99.
       77 ws-temp-total                            pic s9(03)v99.


       77 ws-dia                                   pic 9(02).
       77 ws-ind-temp                              pic 9(02).

       01 ws-uso-comum.
          05 ws-sair                               pic x(01).
          05 ws-msn                                pic x(50).
          05 ws-msn-erro.
             10 ws-msn-erro-ofsset                 pic 9(04).
             10 filler                             pic x(01) value "-".
             10 ws-msn-erro-cod                    pic 9(02).
             10 filler                             pic x(01) value space.
             10 ws-msn-erro-text                   pic x(42).



      *>----Variaveis para comunicação entre programas
       linkage section.


      *>----Declaração de tela
       screen section.

      *>Declaração do corpo do programa
       procedure division.


           perform inicializa.
           perform processamento.
           perform finaliza.

      *>------------------------------------------------------------------------
      *>  Procedimentos de inicialização
      *>------------------------------------------------------------------------
       inicializa section.

           open input arqTemperaturas.
           if ws-fs-arqTemperaturas <> 0 then
               move 1                                     to ws-msn-erro-ofsset
               move ws-fs-arqTemperaturas                 to ws-msn-erro-cod
               move "Erro ao abrir arq. arqTemperaturas " to ws-msn-erro-text
               perform finaliza-anormal
           end-if

           perform varying ws-ind-temp from 1 by 1 until ws-fs-arqTemperaturas = 10
                                                       or ws-ind-temp > 30

               read arqTemperaturas  into  ws-temperaturas(ws-ind-temp)
               if  ws-fs-arqTemperaturas <> 0
               and ws-fs-arqTemperaturas <> 10 then
                   move 2                                     to ws-msn-erro-ofsset
                   move ws-fs-arqTemperaturas                 to ws-msn-erro-cod
                   move "Erro ao ler arq. arqTemperaturas "   to ws-msn-erro-text
                   perform finaliza-anormal
               end-if


           end-perform

           close arqTemperaturas.
           if ws-fs-arqTemperaturas <> 0 then
               move 3                                      to ws-msn-erro-ofsset
               move ws-fs-arqTemperaturas                  to ws-msn-erro-cod
               move "Erro ao fechar arq. arqTemperaturas"  to ws-msn-erro-text
               perform finaliza-anormal
           end-if
           .

       inicializa-exit.
           exit.

      *>------------------------------------------------------------------------
      *>  Processamento principal
      *>------------------------------------------------------------------------
       processamento section.

      *>   chamando rotina de calculo da média de temp.
           perform calc-media-temp

      *>    menu do sistema
           perform until ws-sair = "S"
                      or ws-sair = "s"
               display erase

               display "Dia a ser testado: "
               accept ws-dia

               if  ws-dia >= 1
               and ws-dia <= 30 then
                   if ws-temp(ws-dia) > ws-media-temp then
                       display "A temperatura do dia " ws-dia " esta acima da media"
                       display "media:"  ws-media-temp
                   else
                   if ws-temp(ws-dia) < ws-media-temp then
                           display "A temperatura do dia " ws-dia " esta abaixo da media"
                           display "media:"  ws-media-temp

                   else
                           display "A temperatura esta na media"
                           display "media:" ws-media-temp

                   end-if
                   end-if
               else
                   display "Dia fora do intervalo valido (1 -30)"
               end-if

               display "'T'estar outra temperatura"
               display "'S'air"
               accept ws-sair
           end-perform
           .
       processamento-exit.
           exit.

      *>------------------------------------------------------------------------
      *>  Calculo da média de temperatura
      *>------------------------------------------------------------------------
       calc-media-temp section.

           move 0 to ws-temp-total
           perform varying ws-ind-temp from 1 by 1 until ws-ind-temp > 30
               compute ws-temp-total = ws-temp-total + ws-temp(ws-ind-temp)
           end-perform

           compute ws-media-temp = ws-temp-total/30

           .
       calc-media-temp-exit.
           exit.
      *>------------------------------------------------------------------------
      *>  Finalização anormal
      *>------------------------------------------------------------------------
       finaliza-anormal section.
           display erase
           display ws-msn-erro.
           stop run
           .
       finaliza-anormal-exit.
           exit.

      *>------------------------------------------------------------------------
      *>  Finalização
      *>------------------------------------------------------------------------
       finaliza section.
           stop run
           .
       finaliza-exit.
           exit.













