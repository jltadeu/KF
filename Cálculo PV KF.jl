# Fontes:
# Aircraft Design: A Conceptual Approach
# AIRCRAFT STRUCTURES BY T.H.G. MEGSON
# RC Airplane Workshop Secrets
# METODOLOGIA DE PROJETO CONCEITUAL DE AERONAVES - J.A.B. FLORES

println("PVAsa\n")

# ENTRADAS LONGARINA

println("Envergadura (mm): ")
envergadura_longarina = parse(Float64, readline())
if envergadura_longarina > 1800 || envergadura_longarina <= 0
    println("Envergadura inválida")
    return
end

println("Densidade do Material da longarina (kg/m³): ")
densidade_longarina = parse(Float64, readline())
if densidade_longarina <= 0
    println("Densidade inválida")
    return
end

println("Diâmetro da longarina (m): ")
diametro_longarina = parse(Float64, readline())
if diametro_longarina <= 0
    println("Diâmetro inválido")
    return
end

println("Espessura da longarina (m): ")
espessura_longarina = parse(Float64, readline())
if espessura_longarina <= 0
    println("Espessura inválida")
    return
end

# CÁLCULOS LONGARINA

volume_longarina_externo = pi * (diametro_longarina / 2)^2 * (envergadura_longarina / 1000) # volume maciço da longarina
volume_longarina_interno = pi * ((diametro_longarina / 2) - espessura_longarina)^2 * (envergadura_longarina / 1000) # volume vazio da longarina
volume_longarina = volume_longarina_externo - volume_longarina_interno # volume verdadeiro da longarina
peso_longarina = volume_longarina * densidade_longarina


# ENTRADAS NERVURA

println("\nPVNerv")

envergadura_longarina = 1800 # mm
envergadura_longarina_metros = envergadura_longarina / 1000

println("Área da nervura inicial (m²):  ")
area_nervura_inicial = parse(Float64, readline())
if area_nervura_inicial <= 0
    println("Área inválida")
    return
end

println("Corda nervura inicial (m):  ")
corda_asa_inicial = parse(Float64, readline())
if corda_asa_inicial <= 0
    println("Corda inválida")
    return
end

println("Corda nervura final (m):  ")
corda_asa_final = parse(Float64, readline())
if corda_asa_final <= 0
    println("Corda inválida")
    return
end

println("Espessura da nervura (m):  ")
espessura_nervura = parse(Float64, readline())
if espessura_nervura <= 0
    println("Espessura inválida")
    return
end

println("Densidade da nervura (kg/m³):  ")
densidade_corda_asa = parse(Float64, readline())
if densidade_corda_asa <= 0
    println("Densidade inválida")
    return
end

println("Espaçamento entre nervuras (m):  ")
espaco_nervura_asa = parse(Float64, readline())
if espaco_nervura_asa <= 0 || espaco_nervura_asa > envergadura_longarina_metros
    println("Espaçamento inválido")
    return
end

# CÁLCULOS NERVURAS

global posicao_nervura = 0.0
global area_nervura_total = 0.0
global n_nervuras = 0.0

while posicao_nervura < envergadura_longarina_metros
    global posicao_nervura, area_nervura_total, n_nervuras
    if posicao_nervura == 0.0
        area_nervura = area_nervura_inicial
    else
        area_nervura = area_nervura_inicial * (
            1 - ((corda_asa_inicial - corda_asa_final) / ((envergadura_longarina_metros / 2) * corda_asa_final) * posicao_nervura)^2 # juncao do calculo de variação de corda linear com calculo de area de uma nervura (uma constante vezes a corda ao quadrado)
        )
    end
    area_nervura = max(area_nervura, 0)  # Adicionando protecao contra valores negativos
    area_nervura_total += area_nervura
    posicao_nervura += espessura_nervura + espaco_nervura_asa
    n_nervuras += 1
end

volume_nervura_total = area_nervura_total * espessura_nervura
peso_nervuras = 2 * volume_nervura_total * densidade_corda_asa #pois calculamos somente de 1 asa


# ENTRADAS FUSELAGEM

println("\nPVAFus")

println("Formato da carga paga:\n1 - Cilindro \n2 - Retângulo")
formato_carga_paga = parse(Int, readline())
if !(formato_carga_paga in (1, 2))
    println("Formato inválido")
    return
end

if formato_carga_paga == 1
    println("Diâmetro da carga paga (m): ")
    diametro_carga_paga = parse(Float64, readline())
    if diametro_carga_paga <= 0
        println("Diâmetro inválido")
        return
    end
    altura_carga_paga = diametro_carga_paga
    largura_carga_paga = diametro_carga_paga
else
    println("Altura da carga paga (m): ")
    altura_carga_paga = parse(Float64, readline())
    if altura_carga_paga <= 0
        println("Altura inválida")
        return
    end

    println("Largura da carga paga (m): ")
    largura_carga_paga = parse(Float64, readline())
    if largura_carga_paga <= 0
        println("Largura inválida")
        return
    end
end

println("Comprimento da carga paga (m): ")
comprimento_carga_paga = parse(Float64, readline())
if comprimento_carga_paga <= 0
    println("Comprimento inválido")
    return
end

println("Densidade da fuselagem (kg/m³): ")
densidade_fuselagem = parse(Float64, readline())
if densidade_fuselagem <= 0
    println("Densidade inválida")
    return
end

println("Espessura da fuselagem (m): ")
espessura_fuselagem = parse(Float64, readline())
if espessura_fuselagem <= 0
    println("Espessura inválida")
    return
end

println("Distância do motor ao CG (m): ")
distancia_motor_cg = parse(Float64, readline())
if distancia_motor_cg <= 0
    println("Distância inválida")
    return
end

# CÁLCULOS FUSELAGEM

comprimento_fuselagem = distancia_motor_cg / 0.20 # Estimamos que a distância do motor até o CG seja de 15%–25% (tira-se a média) do comprimento da fuselagem (em um avião triciclo).
volume_externo_fuselagem = comprimento_fuselagem * (altura_carga_paga + 2 * espessura_fuselagem) * (largura_carga_paga + 2 * espessura_fuselagem)

if formato_carga_paga == 1
    volume_interno_fuselagem = pi * (diametro_carga_paga / 2)^2 * comprimento_fuselagem
else
    volume_interno_fuselagem = comprimento_carga_paga * altura_carga_paga * largura_carga_paga
end

volume_fuselagem = volume_externo_fuselagem - volume_interno_fuselagem
peso_fuselagem = volume_fuselagem * densidade_fuselagem


# ENTRADAS TREM DE POUSO

println("\nPVATP")

println("Distância da asa ao chão (m): ")
distancia_asa_chao = parse(Float64, readline())
if distancia_asa_chao <= 0
    println("Distância inválida")
    return
end

println("Densidade do trem de pouso (kg/m³): ")
densidade_trem_pouso = parse(Float64, readline())
if densidade_trem_pouso <= 0
    println("Densidade inválida")
    return
end

println("Espessura do trem de pouso (m): ")
espessura_trem_pouso = parse(Float64, readline())
if espessura_trem_pouso <= 0
    println("Espessura inválida")
    return
end

println("Largura do trem de pouso (m): ")
largura_trem_pouso = parse(Float64, readline())
if largura_trem_pouso <= 0
    println("Largura inválida")
    return
end

println("Comprimento do trem de pouso (m): ")
comprimento_trem_pouso = parse(Float64, readline())
if comprimento_trem_pouso <= 0
    println("Comprimento inválido")
    return
end

# CÁLCULOS TREM DE POUSO

h_tp = distancia_asa_chao - (altura_carga_paga + espessura_fuselagem)
volume_trem = largura_trem_pouso * espessura_trem_pouso * comprimento_trem_pouso #tomando como se ele tivesse um formato retangular
peso_trem = volume_trem * densidade_trem_pouso


# ENTRADAS BEQUILHA

println("Densidade da bequilha (kg/m³): ")
densidade_bequilha = parse(Float64, readline())
if densidade_bequilha <= 0
    println("Densidade inválida")
    return
end

println("Diâmetro da bequilha (m): ")
diametro_bequilha = parse(Float64, readline())
if diametro_bequilha <= 0
    println("Diâmetro inválido")
    return
end

# CÁLCULOS BEQUILHA

h_bq = 0.55 * h_tp #pensando que a altura da bequilha é a altura do trem de pouso vezes um valor entre 0,4 e 0,7 (tira-se a média) 
volume_bequilha = pi * (diametro_bequilha / 2)^2 * h_bq #pensando que a bequilha tem um formato cilíndrico
peso_bequilha = volume_bequilha * densidade_bequilha


# ENTRADAS RODAS

println("Peso da roda (kg): ")
peso_roda = parse(Float64, readline())
if peso_roda <= 0
    println("Peso inválido")
    return
end

# CÁLCULO RODAS

peso_roda_total = 3 * peso_roda #pois são 3 rodas


# PESO TOTAL

peso_vazio = peso_longarina + peso_nervuras + peso_fuselagem + peso_trem + peso_bequilha + peso_roda_total

println("\nResumo Final:")
println("Peso longarina: $peso_longarina kg")
println("Peso nervuras: $peso_nervuras kg")
println("Peso fuselagem: $peso_fuselagem kg")
println("Peso trem de pouso: $peso_trem kg")
println("Peso bequilha: $peso_bequilha kg")
println("Peso rodas: $peso_roda_total kg")
println("\nPeso vazio da aeronave: $peso_vazio kg")
println("E o avião tem $(n_nervuras * 2) nervuras")
