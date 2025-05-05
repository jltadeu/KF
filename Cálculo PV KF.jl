# Fontes:
# Aircraft Design: A Conceptual Approach
# AIRCRAFT STRUCTURES BY T.H.G. MEGSON
# RC Airplane Workshop Secrets
# METODOLOGIA DE PROJETO CONCEITUAL DE AERONAVES - J.A.B. FLORES


#falta: ev, eh, tb, eletrica

# Constantes matemáticas
const pi = 3.1415

#falta: tb, eletrica

#duvidas:

area_nervura_inicial_asa = 0.2 #ver
area_nervura_inicial_eh = 0.1
area_nervura_inicial_ev = 0.1

#inputs vindas do MDO

envergadura_longarina = 1.75 #ok
corda_asa_inicial = 0.4 #ok
corda_asa_final = 0.2 #ok
distancia_motor_cg = 0.25 #ok
distancia_asa_chao = 0.3 #ok

#inputs colocados por nos:

densidade_longarina = 1500 #n
diametro_longarina = 0.03 #n
espessura_longarina = 0.001 #n

espaco_nervura_asa = 0.15 #n
espessura_nervura = 0.003 #
densidade_nervura = 250 #??

densidade_trem_pouso = 1500 #n
espessura_trem_pouso = 0.01 #n
comprimento_trem_pouso = 0.2 #n
largura_trem_pouso = 0.01 #n
peso_roda = 0.05 #n

espessura_bequilha = espessura_trem_pouso
largura_bequilha = largura_trem_pouso
densidade_bequilha = densidade_trem_pouso

densidade_fuselagem = 299 #n
espessura_fuselagem = 0.01 #n
largura_carga_paga = 0.15 #n
comprimento_carga_paga = 0.3 #n
altura_carga_paga = 0.2 

espessura_longarina_eh = espessura_longarina #n
espaco_nervura_eh = 0.10

peso_servo = 0.009
n_servos = 6 
peso_motor = 0.122 # https://www.precisionmicrodrives.com/product/722-401?utm_term=&utm_campaign=Brushless+Shopping+Campaign+2025&utm_source=adwords&utm_medium=ppc&hsa_acc=9693572229&hsa_cam=22182755267&hsa_grp=175701279113&hsa_ad=731160664212&hsa_src=g&hsa_tgt=pla-829976830544&hsa_kw=&hsa_mt=&hsa_net=adwords&hsa_ver=3&gad_source=1&gad_campaignid=22182755267&gbraid=0AAAAAD_S672Xxz-2WCuS3tHBCTV4THmZw&gclid=Cj0KCQjwoNzABhDbARIsALfY8VMsVz1vrsLOVuTYg4FCsmjSnGs7WYxvDkIIKXHYGXVhYuQUHxW1iqMaAlXMEALw_wcB
peso_afiação = 0.05
peso_bateria = 0.220
peso_circuito = 0.06

#Valores calculados que talvez ajudem por enquanto (posteriormente podemos colocar manualmente):

envergadura_estabilizador_horizontal = 0.35 * envergadura_longarina #valor entre 30 e 50% da envergadura da asa
diametro_longarina_eh = 0.6 * diametro_longarina #valor entre 50 e 70% do diametro da longarina da asa
envergadura_estabilizador_vertical = 0.6 * envergadura_estabilizador_horizontal #valor entre 50 e 70% da envergadura do estabilizador horizontal
comprimento_tailboom = 0.7 * envergadura_longarina #valor entre 60 e 80% da envergadura da asa

# CÁLCULOS LONGARINA
volume_longarina_externo = pi * (diametro_longarina / 2)^2 * envergadura_longarina
volume_longarina_interno = pi * ((diametro_longarina / 2) - espessura_longarina)^2 * envergadura_longarina
volume_longarina = volume_longarina_externo - volume_longarina_interno
peso_longarina = volume_longarina * densidade_longarina

# CÁLCULOS NERVURAS (função corrigida)
function calcular_nervuras(area_nervura_inicial,envergadura, corda_asa_inicial, corda_asa_final, espessura, espaco, densidade)
    posicao_nervura = 0.0
    area_total = 0.0
    contador = 0
    
    while posicao_nervura < envergadura/2
        area_nervura = area_nervura_inicial * (
            1 - ((corda_asa_inicial - corda_asa_final) / ((envergadura / 2) * corda_asa_final) * posicao_nervura)^2
        )
        area_total += area_nervura
        posicao_nervura += espaco
        contador += 1
    end
    
    volume_total = area_total * espessura
    peso_total = 2 * volume_total * densidade
    
    return peso_total, contador
end

peso_nervuras, n_nervuras = calcular_nervuras(area_nervura_inicial_asa,
    envergadura_longarina, 
    corda_asa_inicial, 
    corda_asa_final, 
    espessura_nervura, 
    espaco_nervura_asa, 
    densidade_nervura
)

# CÁLCULOS FUSELAGEM
comprimento_fuselagem = distancia_motor_cg / 0.20
volume_externo_fuselagem = (comprimento_fuselagem + 2*espessura_fuselagem) * (altura_carga_paga + 2*espessura_fuselagem) * (largura_carga_paga + 2*espessura_fuselagem)
volume_interno_fuselagem = comprimento_fuselagem * altura_carga_paga * largura_carga_paga
volume_fuselagem = volume_externo_fuselagem - volume_interno_fuselagem
peso_fuselagem = volume_fuselagem * densidade_fuselagem

# CÁLCULOS TREM DE POUSO
h_tp = distancia_asa_chao - (altura_carga_paga + espessura_fuselagem)
volume_trem = largura_trem_pouso * espessura_trem_pouso * comprimento_trem_pouso
peso_trem = volume_trem * densidade_trem_pouso

# CÁLCULOS BEQUILHA
h_bq = 0.55 * h_tp
volume_bequilha = largura_bequilha * espessura_bequilha * h_bq * 2 
peso_bequilha = volume_bequilha * densidade_bequilha

# CÁLCULOS RODAS
peso_roda_total = 3 * peso_roda

# CÁLCULO EH 

# LONGARINA EH

volume_longarina_eh_externo = pi * (diametro_longarina_eh / 2)^2 * envergadura_estabilizador_horizontal
volume_longarina_eh_interno = pi * ((diametro_longarina_eh / 2) - espessura_longarina)^2 * envergadura_estabilizador_horizontal
volume_longarina_eh = volume_longarina_eh_externo - volume_longarina_eh_interno
peso_longarina_eh = volume_longarina_eh * densidade_longarina

# CÁLCULOS NERVURAS EH 

corda_estabilizador_eh = ((envergadura_longarina * (corda_asa_inicial + corda_asa_final) / 2)*0.22)/envergadura_estabilizador_horizontal # area EH é area asa vezes 20% a 25%  


peso_nervuras_eh, n_nervuras_eh = calcular_nervuras(area_nervura_inicial_eh,
    envergadura_estabilizador_horizontal, 
    corda_estabilizador_eh, 
    corda_estabilizador_eh, 
    espessura_nervura, 
    espaco_nervura_eh, 
    densidade_nervura
)

peso_eh = peso_longarina_eh + peso_nervuras_eh

# CÁLCULO EV 

volume_longarina_ev_externo = pi * (diametro_longarina_eh / 2)^2 * envergadura_estabilizador_vertical
volume_longarina_ev_interno = pi * ((diametro_longarina_eh / 2) - espessura_longarina)^2 * envergadura_estabilizador_vertical
volume_longarina_ev = volume_longarina_ev_externo - volume_longarina_ev_interno
peso_longarina_ev = volume_longarina_ev * densidade_longarina

corda_estabilizador_ev = (0.35 * corda_estabilizador_eh * envergadura_estabilizador_horizontal)/envergadura_estabilizador_vertical # area EV é area EH vezes 30% a 40%  

peso_nervuras_ev, n_nervuras_ev = calcular_nervuras(area_nervura_inicial_ev,
    envergadura_estabilizador_vertical, 
    corda_estabilizador_ev, 
    corda_estabilizador_ev, 
    espessura_nervura, 
    espaco_nervura_eh, 
    densidade_nervura
)

peso_ev = peso_longarina_ev + (peso_nervuras_ev/2) #pois o peso_nervuras_ev seria se tivesse os dois lados, para cima e para baixo, mas só tem para cima.

# CÁLCULO TAILBOOM

volume_tb_externo = pi * (diametro_longarina / 2)^2 * comprimento_tailboom
volume_tb_interno = pi * ((diametro_longarina / 2) - espessura_longarina)^2 * comprimento_tailboom
volume_tb = volume_tb_externo - volume_tb_interno
peso_tb = volume_tb * densidade_longarina


# CÁLCULO ELÉTRICA
peso_servo_total = peso_servo * n_servos
peso_eletrica = peso_servo_total + peso_motor + peso_afiação + peso_bateria + peso_circuito 

# PESO TOTAL
peso_vazio = peso_longarina + peso_nervuras + peso_fuselagem + peso_trem + peso_bequilha + peso_roda_total + peso_eh + peso_ev + peso_tb + peso_eletrica

# SAÍDA SIMPLES
println("\nResumo Final:")
println("Peso longarina: ", peso_longarina, " kg")
println("Peso nervuras: ", peso_nervuras, " kg")
println("Peso fuselagem: ", peso_fuselagem, " kg")
println("Peso trem de pouso: ", peso_trem, " kg")
println("Peso bequilha: ", peso_bequilha, " kg")
println("Peso rodas: ", peso_roda_total, " kg")
println("Peso EH: ", peso_eh, " kg")
println("Peso EV: ", peso_ev, " kg")
println("Peso TB: ", peso_tb, " kg")
println("Peso elétrica: ", peso_eletrica, " kg")
println("\nPeso vazio da aeronave: ", peso_vazio, " kg")

