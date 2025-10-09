import { useState, useEffect, useCallback, useMemo } from 'react';
import {
  Col,
  Button,
  FormGroup,
  Input,
  Modal,
  ModalBody,
  ModalHeader,
  ModalFooter,
} from 'reactstrap';
import { Box } from '@mui/material';
import PropTypes from 'prop-types';
import Select from 'react-select';
import Typography from '@mui/material/Typography';
import { toast, ToastContainer } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';
import api from '../../../services/api';
import Loader from '../../../layouts/loader/Loader';
import Excluirregistro from '../../Excluirregistro';
import modoVisualizador from '../../../services/modovisualizador';

// Helpers para normalização (evitam controlled → uncontrolled)
const asStr = (v) => (v ?? '');
const asUpper = (v) => (v ? String(v).toUpperCase() : '');
const asNumOrEmpty = (v) => (v === null || v === undefined ? '' : v);

// Dados das infrações (texto bruto)
const infracaoDataText = `
5002\tMulta, por não identificação do condutor infrator, imposta à pessoa jurídica 
5010\tDirigir veículo sem possuir CNH ou Permissão para Dirigir
5029\tDirigir veículo com CNH ou PPD cassada
5029\tDirigir veículo com CNH ou PPD com suspensão do direito de dirigir
5037\tDirigir veículo com CNH de categoria diferente da do veículo e Dirigir veículo com CNH ou PPD com suspensão do direito de dirigir
5045\tDirigir veículo com validade de CNH/PPD vencida há mais de 30 dias
5053\tDirigir veículo sem usar lentes corretoras de visão e Dirigir veículo sem usar aparelho auxiliar de audição e Dirigir veículo sem usar aparelho auxiliar de prótese física e Dirigir veículo s/ adaptações impostas na concessão/renovação licença conduzir
5061\tEntregar veículo a pessoa sem CNH ou Permissão para Dirigir
5070\tEntregar veículo a pessoa com CNH ou PPD cassada e Entregar veículo a pessoa com CNH ou PPD com suspensão do direito de dirigir
5088\tEntregar veículo a pessoa com CNH de categoria diferente da do veículo e Entregar veículo a pessoa com PPD de categoria diferente da do veículo
5096\tEntregar veículo a pessoa com CNH/PPD vencida há mais de 30 dias
5100\tEntregar o veículo a pessoa sem usar lentes corretoras de visão e Entregar o veículo a pessoa sem usar aparelho auxiliar de audição e Entregar o veículo a pessoa sem usar aparelho de prótese física e Entregar veíc pessoa s/ adaptações impostas concessão/renovação licença conduzir
5118\tPermitir posse/condução do veículo a pessoa sem CNH ou PPD
5126\tPermitir posse/condução do veículo a pessoa com CNH ou PPD cassada e Permitir posse/condução veíc pessoa com CNH/PPD c/ suspensão direito de dirigir
5134\tPermitir posse/condução veíc a pessoa com CNH categoria diferente da do veículo e Permitir posse/condução veíc a pessoa com PPD categoria diferente da do veículo 
5142\tPermitir posse/condução do veíc a pessoa com CNH/PPD vencida há mais de 30 dias 
5150\tPermitir posse/condução do veículo a pessoa sem usar lentes corretoras de visão e Permitir posse/condução do veículo a pessoa s/ usar aparelho auxiliar de audição e Permitir posse/condução do veículo a pessoa sem usar aparelho de prótese física e Permitir posse/cond veíc s/ adaptações impostas concessão/renovação licença cond
5169\tDirigir sob a influência de álcool e Dirigir sob a influência de qquer substância psicoativa que deter. Dependência
5177\tConfiar/entregar veíc pess c/ estado físico/psíquico s/ condições dirigir segur
5185\tDeixar o condutor de usar o cinto segurança e Deixar o passageiro de usar o cinto segurança
5193\tTransportar criança sem observância das normas de segurança estabelecidas p/ CTB
5207\tDirigir sem atenção ou sem os cuidados indispensáveis à segurança
5215\tDirigir ameaçando os pedestres que estejam atravessando a via pública e Dirigir ameaçando os demais veículos 
5223\tUsar veículo para arremessar sobre os pedestres água ou detritos e Usar veículo para arremessar sobre os veículos água ou detritos
5231\tAtirar do veículo objetos ou substâncias e Abandonar na via objetos ou substâncias
5240\tDisputar corrida
5258\tPromover na via competição sem permissão e Promover na via eventos organizados sem permissão e Promover na via exibição e demonstração de perícia em manobra de veículo s/perm 
5266\tParticipar na via como condutor em competição sem permissão e Participar na via como condutor em eventos organizados sem permissão  e Participar como condutor exib/demonst perícia em manobra de veic s/ permissão
5274\tUtiliz veíc demonst/exibir manobra perigosa mediante arrancada brusca e Utiliz veíc dem/exibir manob perig med derrap/frenag c/desliz/arrast pneus
5282\tDeixar o cond envolvido em acidente, de prestar ou providenciar socorro a vítima 
5290\tDeixar o cond envolvido em acid, de adotar provid p/ evitar perigo p/o trânsito
5304\tDeixar o cond envolvido em acidente, de preservar local p/ trab policia/pericia 
5312\tDeixar o cond envolvido em acid, de remover o veíc local qdo determ polic/agente 
5320\tDeixar o cond envolvido em acid, de identificar-se policial e prestar inf p/o BO 
5339\tDeixar o condutor de prestar socorro vítima acid de trânsito, qdo solicit p/ agente 
5347\tDeixar o condutor envolvido em acidente s/ vítima, de remover o veículo do local
5355\tFazer ou deixar que se faça reparo em veíc, em rodovia e via de trânsito rápido 
5363\tFazer/deixar que se faça reparo em veíc nas vias (q não rodovia/transito rapido) 
5371\tTer seu veículo imobilizado na via por falta de combustível 
5380\tEstacionar nas esquinas e a menos de 5m do alinhamento da via transversal 
5398\tEstacionar afastado da guia da calçada (meio-fio) de 50cm a 1m 
5401\tEstacionar afastado da guia da calçada (meio-fio) a mais de 1m 
5410\tEstacionar em desacordo com as posições estabelecidas no CTB 
5428\tEstacionar na pista de rolamento das estradas e Estacionar na pista de rolamento das rodovias e Estacionar na pista de rolamento das vias de trânsito rápido e Estacionar na pista de rolamento das vias dotadas de acostamento 
5436\tEstacionar junto/sobre hidr de incêndio, reg de água/tampa de poço visit gal sub 
5444\tEstacionar nos acostamentos 
5452\tEstacionar no passeio, Estacionar sobre faixa destinada a pedestre, Estacionar sobre ciclovia ou ciclofaixa, Estacionar nas ilhas ou refúgios, Estacionar ao lado ou sobre canteiro central/divisores de pista de rolamento, Estacionar ao lado ou sobre marcas de canalização, Estacionar ao lado ou sobre gramado ou jardim público 
5460\tEstacionar em guia de calçada rebaixada destinada à entrada/saída de veículos 
5479\tEstacionar impedindo a movimentação de outro veículo 
5487\tEstacionar ao lado de outro veículo em fila dupla 
5495\tEstacionar na área de cruzamento de vias 
5509\tEstacionar no ponto de embarque/desembarque de passageiros transporte coletivo 
5517\tEstacionar nos viadutos, Estacionar nas pontes, Estacionar nos túneis 
5525\tEstacionar na contramão de direção 
5533\tEstacionar aclive/declive ñ freado e sem calço segurança, PBT superior a 3500kg 
5541\tEstacionar em desacordo com a regulamentação especificada pela sinalização, estacionamento rotativo, ponto ou vaga de táxi, vaga de carga/descarga, vaga portador necessid especiais, vaga idoso, vaga de curta duração 
5550\tEstacionar em local/horário proibido especificamente pela sinalização 
5568\tEstacionar local/horário de estacionamento e parada proibidos pela sinalização 
5576\tParar nas esquinas e a menos 5m do bordo do alinhamento da via transversal 
5584\tParar afastado da guia da calçada (meio-fio) de 50cm a 1m 
5592\tParar afastado da guia da calçada (meio-fio) a mais de 1m 
5606\tParar em desacordo com as posições estabelecidas no CTB 
5614\tParar na pista de rolamento das estradas, Parar na pista de rolamento das rodovias, Parar na pista de rolamento das vias de trânsito rápido, Parar na pista de rolamento das demais vias dotadas de acostamento 
5622\tParar no passeio, Parar sobre faixa destinada a pedestres, Parar nas ilhas ou refúgios, Parar nos canteiros centrais/divisores de pista de rolamento, Parar nas marcas de canalização 
5630\tParar na área de cruzamento de vias 
5649\tParar nos viadutos, Parar nas pontes, Parar nos túneis
5657\tParar na contramão de direção 
5665\tParar em local/horário proibidos especificamente pela sinalização 
5673\tParar sobre faixa de pedestres na mudança de sinal luminoso, e (fisc eletrônica)
5681\tTransitar na faixa/pista da direita regul circulação exclusiva determ veículo 
5690\tTransitar na faixa/pista da esquerda regul circulação exclusiva determ veículo 
5703\tDeixar de conservar o veículo na faixa a ele destinada pela sinalização de regul 
5711\tDeixar de conservar nas faixas da direita o veículo lento e de maior porte 
5720\tTransitar pela contramão de direção em via com duplo sentido de circulação 
5738\tTransitar pela contramão de direção em via c/ sinalização de regul sentido único 
5746\tTransitar em local/horário não permitido pela regul estabelecida p/ autoridade,  rodízio, caminhão
5762\tTransitar ao lado de outro veículo, interrompendo ou perturbando o trânsito 
5770\tDeixar de dar passagem a veíc precedido de batedores devidamente identificados, Deixar de dar passagem a veíc socorro incêndio/salv serv urgência devid identif, Deixar de dar passagem a veíc de polícia em serviço de urgência devid identif, Deixar de dar passagem a veíc de operação e fiscalização de trânsito devid ident, Deixar de dar passagem a ambulância em serviço de urgência devid identificada
5789\tSeguir veículo em serv urgência devid identific p/ alarme sonoro/ilum vermelha 
5797\tForçar passagem entre veícs trans sent opostos na iminência realiz ultrapassagem 
5800\tDeixar guardar dist segurança lat/front entre seu veíc e demais e ao bordo pista 
5819\tTransitar com o veículo em calçadas, passeios, Transitar com o veículo em ciclovias, ciclofaixas - Transitar com o veículo em ajardinamentos, gramados, jardins públicos - Transitar com o veículo em canteiros centrais/divisores de pista de rolamento - Transitar com o veículo em ilhas, refúgios - Transitar com o veículo em marcas de canalização - Transitar com o veículo em acostamentos - Transitar com o veículo em passarelas
5827\tTransitar em marcha ré, salvo na distância necessária a pequenas manobras 
5835\tDesobedecer às ordens emanadas da autorid compet de trânsito ou de seus agentes 
5843\tDeixar de indicar c/ antec, med gesto de braço/luz indicadora, início da marcha - Deixar de indicar c/ antec, med gesto de braço/luz indicadora, manobra de parar - Deixar de indicar c/ antec, med gesto de braço/luz indicadora, mudança direção - Deixar de indicar c/ antec, med gesto de braço/luz indicadora, mudança de faixa 
5851\tDeixar de deslocar c/antecedência veíc p/ faixa mais à esquerda qdo for manobrar - Deixar de deslocar c/antecedência veíc p/ faixa mais à direita qdo for manobrar
5860\tDeixar de dar passagem pela esquerda quando solicitado 
5878\tUltrapassar pela direita, salvo qdo veíc da frente der sinal p/ entrar esquerda 
5886\tUltrap pela direita veíc transp colet/escolar parado para emb/desemb passageiros 
5894\tDeixar de guardar a distância lateral de 1,50m ao passar/ultrapassar bicicleta 
5908\tUltrapassar pelo acostamento 
5916\tUltrapassar em interseções - Ultrapassar em passagem de nível 
5924\tUltrapassar pela contramão nas curvas sem visibilidade suficiente - Ultrapassar pela contramão nos aclives ou declives, sem visibilidade suficiente
5932\tUltrapassar pela contramão nas faixas de pedestre 
5940\tUltrapassar pela contramão nas pontes - Ultrapassar pela contramão nos viadutos - Ultrapassar pela contramão nos túneis
5959\tUltrapassar pela contramão veículo parado em fila junto sinal luminoso - Ultrapassar pela contramão veículo parado em fila junto a cancela/porteira - Ultrapassar pela contramão veículo parado em fila junto a cruzamento - Ultrapassar pela contramão veíc parado em fila junto qq impedimento à circulação 
5967\tUltrapassar pela contramão linha de divisão de fluxos opostos, contínua amarela 
5975\tDeixar de parar no acostamento à direita, p/ cruzar pista ou entrar à esquerda 
5983\tUltrapassar veículo em movimento que integre cortejo/desfile/formação militar 
5991\tExecutar operação de retorno em locais proibidos pela sinalização 
6009\tExecutar operação de retorno nas curvas - Executar operação de retorno nos aclives ou declives - Executar operação de retorno nos pontes - Executar operação de retorno nos viadutos - Executar operação de retorno nos túneis 
6017\tExecutar operação de retorno passando por cima de calçada, passeio - Executar operação de retorno passando por cima de ilha, refúgio - Executar operação de retorno passando por cima de ajardinamento - Executar operação de retorno passando por cima de canteiro de divisor de pista - Executar operação de retorno passando por cima de faixa de pedestres - Executar operação de retorno passando por cima de faixa de veíc não motorizados 
6025\tExecutar retorno nas interseções, entrando na contramão da via transversal 
6033\tExecutar retorno c/prejuízo da circulação/segurança ainda que em local permitido 
6041\tExecutar operação de conversão à direita em local proibido pela sinalização - Executar operação de conversão à esquerda em local proibido pela sinalização
6050\tAvançar o sinal vermelho do semáforo - Avançar o sinal de parada obrigatória - Avançar o sinal vermelho do semáforo - fiscalização eletrônica 
6068\tTranspor bloqueio viário com ou sem sinalização ou dispositivos auxiliares - Deixar de adentrar às áreas destinadas à pesagem de veículos - Evadir-se para não efetuar o pagamento do pedágio 
6076\tTranspor bloqueio viário policial 
6084\tUltrapassar veículos motorizados em fila, parados em razão de sinal luminoso - Ultrapassar veículos motorizados em fila, parados em razão de cancela - Ultrapassar veíc motorizados em fila parados em razão de bloqueio viário parcial - Ultrapassar veículos motorizados em fila, parados em razão de qualquer obstáculo 
6092\tDeixar de parar o veículo antes de transpor linha férrea 
6106\tDeixar de parar sempre que a marcha for interceptada por agrupamento de pessoas 
6114\tDeixar de parar sempre que a marcha for interceptada por agrupamento de veículos 
6122\tDeixar de dar preferência a pedestre/veic ñ motorizado na faixa a ele destinada 
6130\tDeixar de dar preferência a pedestre/veic ñ mot que ñ haja concluído a travessia 
6149\tDeixar de dar preferência a pedestre port deficiência fís/criança/idoso/gestante 
6157\tDeixar de dar preferência a pedestre/veic ñ mot qdo iniciada travessia s/sinaliz 
6165\tDeixar de dar preferência a pedestre/veic não mot atravessando a via transversal 
6173\tDeixar de dar preferência em interseção ñ sinaliz, a veíc circulando por rodovia - Deixar de dar preferência em interseção ñ sinaliz, veíc circulando por rotatória - Deixar de dar prefer em interseção não sinalizada, a veículo que vier da direita 
6181\tDeixar de dar preferência nas interseções com sinalização de Dê a Preferência 
6190\tEntrar/sair área lindeira sem precaução com a segurança de pedestres e veículos 
6203\tEntrar/sair de fila de veículos estacionados sem dar pref a pedestres/veículos 
6254\tTransitar em velocidade inferior à metade da máxima da via, salvo faixa direita 
6262\tDeixar de reduzir a veloc qdo se aproximar de passeata/aglomeração/desfile/etc 
6270\tDeixar de reduzir a veloc onde o trânsito esteja sendo controlado pelo agente 
6289\tDeixar de reduzir a velocidade do veículo ao aproximar-se da guia da calçada - Deixar de reduzir a velocidade do veículo ao aproximar-se do acostamento
6297\tDeixar de reduzir velocidade do veículo ao aproximar-se interseção ñ sinalizada 
6300\tDeixar reduzir velocidade nas vias rurais cuja faixa domínio não esteja cercada 
6319\tDeixar de reduzir a velocidade nos trechos em curva de pequeno raio 
6327\tDeixar de reduzir veloc ao aproximar local sinaliz advert de obras/trabalhadores 
6335\tDeixar de reduzir a velocidade sob chuva/neblina/cerração/ventos fortes 
6343\tDeixar de reduzir a velocidade quando houver má visibilidade 
6351\tDeixar de reduzir veloc qdo pavimento se apresentar escorreg/defeituoso/avariado 
6360\tDeixar de reduzir a velocidade à aproximação de animais na pista 
6378\tDeixar de reduzir a velocidade de forma compatível com a segurança, em declive 
6386\tDeixar de reduzir veloc de forma compatível c/ segurança ao ultrapassar ciclista 
6394\tDeixar de reduzir a velocidade nas proximidades de escolas - Deixar de reduzir a velocidade nas proximidades de hospitais - Deixar de reduzir veloc na proxim estação embarque/desembarque passageiros - Deixar de reduzir veloc onde haja intensa movimentação de pedestres 
6408\tPortar no veículo placas de identificação em desacordo c/ especif/modelo Contran 
6416\tConfec/distribuir/colocar veíc próprio/terceiro placa identif desacordo Contran 
6424\tDeixar de manter ligado em emerg sist ilum vermelha intermitente ainda q parado 
6432\tTransitar com farol desregulado perturbando visão outro condutor - Transitar com o facho de luz alta perturbando visão outro condutor
6440\tFazer uso do facho de luz alta dos faróis em vias providas de iluminação pública 
6459\tDeixar de sinalizar via p/ tornar visível local qdo tiver remover veíc da pista - Deixar de sinalizar a via p/ tornar visível o local qdo permanecer acostamento
6467\tDeixar de sinalizar a via p/ tornar visível o local qdo a carga for derramada 
6475\tDeixar de retirar qualquer objeto utilizado para sinalização temporária da via 
6483\tUsar buzina que não a de toque breve como advertência a pedestre ou condutores 
6491\tUsar buzina prolongada e sucessivamente a qualquer pretexto 
6505\tUsar buzina entre as vinte e duas e as seis horas 
6513\tUsar buzina em locais e horários proibidos pela sinalização 
6521\tUsar buzina em desacordo c/ os padrões e freqüências estabelecidas pelo Contran 
6530\tUsar no veículo equip c/ som em volume/freqüência não autorizados pelo Contran 
6548\tUsar no veíc alarme/aparelho produz som perturbe sossego púb desac norma Contran 
6556\tConduzir o veículo com o lacre de identificação violado/falsificado - Conduzir o veículo com a inscrição do chassi violada/falsificada - Conduzir o veículo com o selo violado/falsificado - Conduzir o veículo com a placa violada/falsificada - Conduzir o veículo com qualquer outro elem de identificação violado/falsificado 
6564\tConduzir o veículo transportando passageiros em compartimento de carga 
6572\tConduzir o veículo com dispositivo antirradar 
6580\tConduzir o veículo sem qualquer uma das placas de identificação 
6599\tConduzir o veículo que não esteja registrado - Conduzir o veículo registrado que não esteja devidamente licenciado
6602\tConduzir o veículo com qualquer uma das placas sem legibilidade e visibilidade 
6610\tConduzir o veículo com a cor alterada - Conduzir o veículo com característica alterada 
6629\tConduzir veículo s/ ter sido submetido à inspeção seg veicular, qdo obrigatória 
6637\tConduzir o veículo sem equipamento obrigatório - Conduzir o veículo com equipamento obrigatório ineficiente/inoperante
6645\tConduzir o veículo com equip obrigatório em desacordo com o estab pelo Contran 
6653\tConduzir o veículo com descarga livre - Conduzir o veículo com silenciador de motor defeituoso/deficiente/inoperante
6661\tConduzir o veículo com equipamento ou acessório proibido 
6670\tConduzir o veículo c/ equip do sistema de iluminação e de sinalização alterados 
6688\tConduzir veíc c/ registrador instan inalt de velocidade/tempo viciado/defeituoso 
6696\tConduzir c/ inscr/adesivo/legenda/símbolo afixado pára-brisa e extensão traseira - Conduzir c/ inscr/adesivo/legenda/símbolo pintado pára-brisa e extensão traseira
6700\tConduzir veíc com vidro total/parcialmente coberto por película, painéis/pintura 
6718\tConduzir o veículo com cortinas ou persianas fechadas 
6726\tConduzir o veículo em mau estado de conservação, comprometendo a segurança - Conduzir o veículo reprovado na avaliação de inspeção de segurança - Conduzir o veículo reprovado na avaliação de emissão de poluentes e ruído 
6734\tConduzir o veículo sem acionar o limpador de pára-brisa sob chuva 
6742\tConduzir o veículo sem portar a autorização para condução de escolares 
6750\tConduzir o veíc de carga c/ falta inscrição da tara e demais previstas no CTB 
6769\tConduzir o veículo com defeito no sistema de iluminação/lâmpada queimada - Conduzir o veículo com defeito no sistema de sinalização/lâmpada queimada 
6777\tTransitar com o veículo danificando a via, suas instalações e equipamentos
6785\tTransitar com veículo derramando a carga que esteja transportando - Transitar com veículo lançando a carga que esteja transportando - Transitar com veículo arrastando a carga que esteja transportando 
6793\tTransitar com veíc derramando/lançando combustível/lubrif que esteja utilizando 
6807\tTransitar c/veíc derraman/lançando/arrastando objeto possa acarretar risco acid 
6815\tTransitar com veículo produzindo fumaça, gases ou partículas em desac c/ Contran 
6823\tTransitar c/ veíc e/ou carga c/ dimensões superiores limite legal s/ autorização - Transitar c/ veíc e/ou carga c/ dimensões superiores est p/sinalização s/autoriz
6831\tTransitar com o veículo com excesso de peso PBT/PBTC - Transitar com o veículo com excesso de peso - Por Eixo - Transitar com o veículo com excesso de peso - PBT/PBTC e Por Eixo 
6840\tTransitar em desacordo c/ autorização expedida p/veículo c/ dimensões excedentes - Transitar com autorização vencida, expedida p/ veículo c/ dimensões excedentes
6858\tTransitar com o veículo com lotação excedente 
6866\tTransitar efetuando transporte remunerado de pessoas qdo ñ licenciado p/esse fim - Transitar efetuando transporte remunerado de bens qdo não licenciado p/ esse fim
6874\tTransitar com o veículo desligado em declive - Transitar com o veículo desengrenado em declive
6882\tTransitar com o veículo excedendo a CMT em até 600 kg 
6890\tTransitar com o veículo excedendo a CMT entre 601 e 1.000 kg
6904\tTransitar com o veículo excedendo a CMT acima de 1.000 kg 
6912\tConduzir veículo sem os documentos de porte obrigatório referidos no CTB  
6920\tDeixar de efetuar registro do veículo em 30 dias, qdo for transf a propriedade - Deixar de efetuar reg do veíc em 30 dias, qdo mudar o munic de domicilio/resid - Deixar de efetuar reg de veíc em 30 dias, qdo for alterada qquer caract do veic - Deixar de efetuar registro de veículo em 30 dias, qdo houver mudança de categoria
6939\tFalsificar ou adulterar documento de habilitação - Falsificar ou adulterar documento de identificação do veículo
6947\tConduzir pessoas nas partes externas do veículo - Conduzir animais nas partes externas do veículo - Conduzir carga nas partes externas do veículo 
6955\tRebocar outro veículo com cabo flexível ou corda 
6963\tTrans c/veíc desac c/especificação/falta de inscr/simbologia necessária identif 
6971\tRecusar-se a entregar CNH/CRV/CRLV/ outros documentos 
6980\tRetirar do local veículo legalmente retido para regularização, sem permissão 
6998\tDeixar responsável de promover baixa registro de veíc irrecuperável/desmontado 
7005\tDeixar de atualizar o cadastro de registro do veículo - Deixar de atualizar o cadastro de habilitação do condutor
7013\tFazer falsa declaração de domicílio para fins de registro/licenciamento - Fazer falsa declaração de domicílio para fins de habilitação
7021\tDeixar seguradora de comunicar ocorrência perda total veíc e devolver placas/doc 
7030\tConduzir motocicleta, motoneta e ciclomotor sem capacete de segurança - Conduzir motocicleta, motoneta e ciclomotor sem vestuário aprovado pelo Contran
7048\tConduzir motocicleta, motoneta e ciclomotor transportando passageiro s/ capacete - Conduzir motocicleta/motoneta/ciclomotor transportando pas. fora do assento
7056\tConduzir motoc/moton/ciclomotor fazendo malabarismo/equilibrando-se em uma roda - Conduzir ciclo fazendo malabarismo ou equilibrando-se em uma roda
7064\tConduzir motocicleta, motoneta e ciclomotor com os faróis apagados 
7072\tConduzir motocicleta/motoneta/ciclomotor transportando criança menor de 7 anos - Conduzir motoc/moton/ciclom transp criança s/ condição cuidar própria segurança
7080\tConduzir motocicleta, motoneta e ciclomotor rebocando outro veículo 
7099\tConduzir motocicleta/motoneta/ciclomotor sem segurar o guidom com ambas as mãos 
7102\tConduzir motocicleta, motoneta e ciclomotor transportando carga incompatível - Conduzir motoc/moton/ transportando carga em desacordo c/ § 2º do Art 139-A CTB
7110\tConduzir ciclo transportando passageiro fora da garupa/assento a ele destinado 
7129\tConduzir ciclo via de trâns rápido ou rodovia salvo se houver acostam/fx própria - Conduzir ciclomotor em via de trânsito rápido - Conduzir ciclomotor em rodovia salvo se houver acostamento ou faixa própria
7137\tConduzir ciclo transportando criança s/ condição de cuidar própria segurança 
7145\tUtilizar a via para depósito de mercadorias, materiais ou equipamentos 
7153\tDeixar de sinalizar obstáculo à circulação/segurança calçada/pista-s/agravamento - Obstaculizar a via indevidamente-s/agravamento
7161\tDeixar de sinalizar obstáculo circulação/segurança calçada/pista-agravamento 2X - Obstaculizar a via indevidamente-agravamento 2X
7170\tDeixar de sinalizar obstáculo circulação/segurança calçada/pista-agravamento 3X - Obstaculizar a via indevidamente-agravamento 3X
7188\tDeixar de sinalizar obstáculo circulação/segurança calçada/pista-agravamento 4X - Obstaculizar a via indevidamente-agravamento 4X
7196\tObstaculizar a via indevidamente-agravamento 5X 
7200\tDeixar de conduzir pelo bordo pista em fila única veíc tração/propulsão humana - Deixar de conduzir pelo bordo da pista em fila única veículo de tração animal 
7218\tTransportar em veíc destinado transp passageiros carga excedente desac art.109 
7226\tDeixar de manter acesas à noite as luzes posição qdo o veículo estiver parado - Deixar de manter acesas à noite as luzes de posição veic fazendo carga/descarg a 
7234\tEm movimento, deixar de manter acesa a luz baixa durante à noite 
7242\tEm movimento de dia, deixar de manter acesa luz baixa túnel com iluminação pública
7250\tEm mov, deixar de manter acesa luz baixa veíc transp coletivo faixa/pista excl 
7269\tEm movimento, deixar de manter acesa luz baixa do ciclomotor 
7277\tEm mov deixar de manter acesas luzes de posição sob chuva forte/neblina/cerração 
7285\tEm movimento, deixar de manter a placa traseira iluminada à noite 
7293\tUtilizar o pisca-alerta, exceto em imobilizações ou situações de emergência 
7307\tUtilizar luz alta e baixa intermitente, exceto quando permitido pelo CTB 
7315\tDirigir o veículo com o braço do lado de fora 
7323\tDirigir o veículo transport pessoas à sua esquerda ou entre os braços e pernas - Dirigir o veículo transport animais à sua esquerda ou entre os braços e pernas - Dirigir o veículo transport volume à sua esquerda ou entre os braços e pernas 
7331\tDirigir o veículo com incapacidade física ou mental temporária 
7340\tDirigir o veíc usando calçado que ñ se firme nos pés/comprometa utiliz pedais 
7358\tDirigir o veículo com apenas uma das mãos, exceto quando permitido pelo CTB 
7366\tDirigir o veículo utilizando-se de fones nos ouvidos conec a aparelhagem sonora - Dirigir veículo utilizando-se de telefone celular 
7374\tBloquear a via com veículo 
7382\tÉ proib ao pedestre permanecer/andar pista, exceto p/ cruzá-las onde permitido 
7390\tÉ proibido ao pedestre cruzar pista de rolamento de viaduto exc onde permitido - de ponte exceto onde permitido - de túneis exceto onde permitido 
7404\tÉ proib ao pedestre atravessar via área cruzamento exc onde permitido p/ sinaliz 
7412\tÉ proib pedestre utilizar via em agrupam que perturbe trâns/prát esporte/desfile 
7420\tÉ proibido ao pedestre andar fora da faixa própria - andar fora da passarela - andar fora da passagem aérea - andar fora da passagem subterrânea
7439\tÉ proibido ao pedestre desobedecer a sinalização de trânsito específica 
7447\tConduzir bicicleta em passeios onde não seja permitida a circulação desta - Conduzir bicicleta de forma agressiva 
7455\tTransitar em velocidade superior à máxima permitida em até 20% 
7463\tTransitar em velocidade superior à máxima permitida em mais de 20% até 50% 
7471\tTransitar em velocidade superior à máxima permitida em mais de 50% 
7480\tAprovar proj edificação pólo atrativo trânsito s/ anuência órgão/entid trânsito e Aprovar proj edificação pólo atrativo trâns s/ estacion/indicação vias de acesso 
7498\tÑ sinalizar devida/imed obstáculo à circul/segurança veíc/pedestre pista/calçada 
7501\tUtilizar ondulação transversal/sonorizador fora padrão/critério estab p/ Contran 
7510\tIniciar obra perturbe/interrompa circulação/segurança veíc/pedestres s/permissão e Iniciar evento perturbe/interrompa circulaç/segurança veíc/pedestres s/permissão 
7528\tNão sinalizar a execução ou manutenção da obra e Não sinalizar a execução ou manutenção do evento 
7536\tNão avisar comunidade c/ 48h antec interdição via indicando caminho alternativo 
7544\tFalta de escrituração livro registro entrada/saída e de uso placa de experiência - Atraso escrituração livro registro entrada/saída e de uso placa de experiência - Fraude escrituração livro registro entrada/saída e de uso placa de experiência - Recusa da exibição do livro registro entrada/saída e de uso placa de experiência 
7552\tConduzir motoc/moton/ efetuando transp remun mercadoria desac c/ art 139-A CTB - Conduzir motoc/moton/ efet transp remun desac normas ativid profic mototaxistas
7560\tConduzir veíc de transp passag ou carga em desacordo c/ as cond do art 67-C CTB 
7579\tCond que se recusar a se submeter a qq dos proc prev no art. 277 do CTB
7587\tTransitar na faixa ou via exclusiva regulam. p/ transp. públ. coletivo passag.
7595\tDirigir veículo realizando cobrança de tarifa com veículo em movimento
7609\tOrganizar as condutas previstas no caput do art. 253-A
7617\tUsar veículo para, deliberadamente, interromper a circulação na via - restringir a circulação na via - perturbar a circulação na via
`;

const naturezaPontuacaoText = `
---
7 - Gravíss 3X
7 - Gravíss 5X
7 - Gravíss 5X
7 - Gravíss 3X
7 - Gravíss
7 - Gravíss
7 - Gravíss 3X
7 - Gravíss 5X
7 - Gravíss 3X
7 - Gravíss
7 - Gravíss
7 - Gravíss 3X
7 - Gravíss 5X
7 - Gravíss 3X
7 - Gravíss
7 - Gravíss
Gravíss 10X
7 - Gravíss
5 - Grave
7 - Gravíss
3 - Leve
Gravíss
4 - Média
4 - Média
Gravíss 10X
Gravíss 10X
Gravíss 10X
Gravíss 10X
Gravíss 5X
Gravíss 5X
Gravíss 5X
Gravíss 5X
Gravíss 5X
5 - Grave
4 - Média
5 - Grave
3 - Leve
4 - Média
4 - Média
3 - Leve
5 - Grave
4 - Média
7 - Gravíss
4 - Média
3 - Leve
5 - Grave
4 - Média
4 - Média
5 - Grave
5 - Grave
4 - Média
5 - Grave
4 - Média
5 - Grave
5 - Grave
4 - Média
5 - Grave
4 - Média
3 - Leve
4 - Média
3 - Leve
5 - Grave
3 - Leve
4 - Média
4 - Média
4 - Média
4 - Média
4 - Média
3 - Leve
5 - Grave
4 - Média
4 - Média
5 - Grave
7 - Gravíss
4 - Média
4 - Média
7 - Gravíss
5 - Grave
Gravíss 10X
5 - Grave
7 - Gravíss 3X
5 - Grave
5 - Grave
5 - Grave
4 - Média
4 - Média
4 - Média
7 - Gravíss
4 - Média
7 - Gravíss 5X
7 - Gravíss 5X
7 – Gravíss 5X
7 – Gravíss 5X
7 – Gravíss 5X
7 – Gravíss 5X
7 – Gravíss 5X
5 - Grave
3 - Leve
7 - Gravíss
7 - Gravíss
7 - Gravíss
7 - Gravíss
7 - Gravíss
5 - Grave
7 - Gravíss
5 - Grave
Gravíss
5 - Grave
7 - Gravíss
7 - Gravíss
5 - Grave
7 - Gravíss
7 - Gravíss
7 - Gravíss
5 - Grave
5 - Grave
5 - Grave
5 - Grave
4 - Média
4 - Média
4 - Média
7 - Gravíss
5 - Grave
5 - Grave
5 - Grave
5 - Grave
5 - Grave
5 - Grave
5 - Grave
5 - Grave
5 - Grave
5 - Grave
5 - Grave
5 - Grave
7 - Gravíss
4 - Média
Média
4 - Média
5 - Grave
3 - Leve
5 - Grave
5 - Grave
4 - Média
3 - Leve
3 - Leve
3 - Leve
3 - Leve
3 - Leve
5 - Grave
4 - Média
7 - Gravíss
7 - Gravíss
7 - Gravíss
7 - Gravíss
7 - Gravíss
7 - Gravíss
5 - Grave
5 - Grave
5 - Grave
5 - Grave
5 - Grave
5 - Grave
5 - Grave
5 - Grave
5 - Grave
5 - Grave
5 - Grave
5 - Grave
5 - Grave
5 - Grave
4 - Média
4 - Média
7 - Gravíss
7 - Gravíss
7 - Gravíss
7 - Gravíss
5 - Grave
5 - Grave
4 - Média
5 - Grave
4 - Média
4 - Média
4 - Média
4 - Média
5 - Grave
7 - Gravíss
3 - Leve
5 - Grave
7 - Gravíss
5 - Grave
4 - Média
5 - Grave
7 - Gravíss
7 - Gravíss
5 - Grave
3 - Leve
7 - Gravíss
5 - Grave
Gravíss
Gravíss
Gravíss
Gravíss
Gravíss
5 - Grave
5 - Grave
5 - Grave
4 - Média
4 - Média
4 - Média
Grave
Gravíss
Gravíss 2X
Gravíss 3X
Gravíss 4X
Gravíss 5X
4 - Média
5 - Grave
4 - Média
4 - Média
4 - Média
4 - Média
4 - Média
4 - Média
4 - Média
4 - Média
4 - Média
4 - Média
4 - Média
4 - Média
4 - Média
4 - Média
4 - Média
7 - Gravíss
3 - Leve 50%
3 - Leve 50%
3 - Leve 50%
3 - Leve 50%
3 - Leve 50%
3 - Leve 50%
4 - Média
4 - Média
5 - Grave
Gravíss 3X
---
---
---
---
---
---
Gravíss
5 - Grave
4 – Média 
       Gravíss 10X
7-Gravíss
Média
Gravíss 100X
Gravíss 30 X
`;

const DEPARTAMENTOS_TELE_EQUIPE = [
  'ERICSSON - MG',
  'ERICSSON - NE',
  'ERICSSON - RJ',
  'ERICSSON - SP',
  'HUAWEI - MG',
  'HUAWEI - NE',
  'HUAWEI - RJ',
  'HUAWEI - SP',
  'TELEFONICA - MG',
  'TELEFONICA - NE',
  'TELEFONICA - NO',
  'TELEFONICA - SP',
  'ZTE - MG',
  'ZTE - NE',
  'ZTE - NO',
  'ZTE - RJ',
  'ZTE - SP',
  'Site',
];

const infracaoDataLines = infracaoDataText.trim().split('\n');
const naturezaPontuacaoLines = naturezaPontuacaoText.trim().split('\n');

function parseNaturezaPontuacao(line) {
  line = line.trim();
  if (line === '---' || line === '') {
    return { pontuacao: '', natureza: '' };
  }
  // Normaliza hífens longos para hífen simples
  line = line.replace(/–/g, '-');
  const regex = /^(\d+)\s*-?\s*(.+)$/;
  const match = line.match(regex);
  if (match) {
    const pontuacao = match[1].trim();
    const natureza = match[2].trim();
    return { pontuacao, natureza };
  }
  return { pontuacao: '', natureza: line };
}

const infracaoOptions = infracaoDataLines.map((line, index) => {
  const parts = line.split('\t');
  const code = parts[0].trim();
  const desdobramento = parts.length > 2 ? parts[1].trim() : '';
  const description =
    parts.length > 2 ? parts.slice(2).join(' ').trim() : parts[1] ? parts[1].trim() : '';
  const value = desdobramento ? `${code}-${desdobramento}` : code;
  const naturezaPontuacaoLine = naturezaPontuacaoLines[index] || '';
  const { pontuacao, natureza } = parseNaturezaPontuacao(naturezaPontuacaoLine);
  return {
    value,
    label: `${value} - ${description}`,
    pontuacao,
    natureza,
  };
});

// ======== HELPERS EXTRA (rateio + valor + datas + normalização) ========
const pickDepartamentoFromRateio = (rateio) => {
  if (!Array.isArray(rateio) || rateio.length === 0) return { departamento: '', idsite: '' };
  const r0 = rateio[0] || {};
  const tipo = String(r0.tipo || '').toUpperCase();
  if (tipo === 'SITE') {
    return { departamento: 'Site', idsite: r0.idsite || '' };
  }
  return { departamento: r0.departamento || '', idsite: '' };
};

// aceita "333", "333,50", "1.234,56" -> "1234.56"
const normalizeMoney = (s) => {
  if (s == null) return '';
  const str = String(s).replace(/[^\d.,]/g, '');
  if (str.includes(',') && str.includes('.')) {
    return str.replace(/\./g, '').replace(',', '.');
  }
  return str.replace(',', '.');
};

// Converte QUALQUER formato comum -> "YYYY-MM-DDTHH:mm" (para <input type="datetime-local">)
const toDateTimeLocal = (input) => {
  if (!input) return '';
  let s = String(input).trim();
  // trata strings com "\/" vindas de JSON
  s = s.replace(/\\\//g, '/');

  // Já está no formato local?
  const mLocal = s.match(/^(\d{4}-\d{2}-\d{2})[T ](\d{2}):(\d{2})(?::\d{2})?/);
  if (mLocal) return `${mLocal[1]}T${mLocal[2]}:${mLocal[3]}`;

  // BR: "DD/MM/YYYY HH:mm[:ss]"
  const mBr = s.match(/^(\d{2})\/(\d{2})\/(\d{4})[ T](\d{2}):(\d{2})(?::\d{2})?/);
  if (mBr) {
    const [, dd, mm, yyyy, hh, mi] = mBr;
    return `${yyyy}-${mm}-${dd}T${hh}:${mi}`;
  }

  // ISO com espaço: "YYYY-MM-DD HH:mm[:ss]"
  const mIsoSpace = s.match(/^(\d{4})-(\d{2})-(\d{2})[ ](\d{2}):(\d{2})(?::\d{2})?/);
  if (mIsoSpace) {
    const [, yyyy, mm, dd, hh, mi] = mIsoSpace;
    return `${yyyy}-${mm}-${dd}T${hh}:${mi}`;
  }

  // Fallback: tentar Date.parse
  const ts = Date.parse(s);
  if (!Number.isNaN(ts)) {
    const d = new Date(ts);
    const yyyy = d.getFullYear();
    const mm = String(d.getMonth() + 1).padStart(2, '0');
    const dd = String(d.getDate()).padStart(2, '0');
    const hh = String(d.getHours()).padStart(2, '0');
    const mi = String(d.getMinutes()).padStart(2, '0');
    return `${yyyy}-${mm}-${dd}T${hh}:${mi}`;
  }
  return '';
};

// Converte "YYYY-MM-DDTHH:mm" -> "DD/MM/YYYY HH:mm:00" (pra enviar ao backend)
const toIsoSqlDatetime = (localDt) => {
  if (!localDt) return '';
  const m = String(localDt).match(/^(\d{4})-(\d{2})-(\d{2})T?(\d{2}):(\d{2})/);
  if (!m) return '';
  const [, yyyy, mm, dd, hh, mi] = m;
  return `${yyyy}-${mm}-${dd} ${hh}:${mi}:00`;
};

// normaliza string pra comparações (remove acentos, espaços múltiplos, upper)
const norm = (s) =>
  (s || '')
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/\s+/g, ' ')
    .trim()
    .toUpperCase();
// ======================================================================

function TabPanel(props) {
  const { children, value, index, ...other } = props;
  return (
    <div
      role="tabpanel"
      hidden={value !== index}
      id={`simple-tabpanel-${index}`}
      aria-labelledby={`simple-tab-${index}`}
      {...other}
    >
      {value === index && (
        <Box sx={{ p: 3 }}>
          <Typography>{children}</Typography>
        </Box>
      )}
    </div>
  );
}

TabPanel.propTypes = {
  children: PropTypes.node,
  index: PropTypes.number.isRequired,
  value: PropTypes.number.isRequired,
};

const Multasedicao = ({ setshow, show, ididentificador, atualiza }) => {
  const [mensagem, setmensagem] = useState('');
  const [mensagemsucesso, setmensagemsucesso] = useState('');
  const [loading, setloading] = useState(false);
  const [telaexclusao, settelaexclusao] = useState('');
  const [idmultas, setidmultas] = useState(''); // string para manter controlado
  const [nomeindicado, setnomeindicado] = useState(''); // não é exibido, mas mantém consistência
  const [placa, setplaca] = useState('');
  const [departamento, setdepartamento] = useState('');
  const [numeroait, setnumeroait] = useState('');
  const [datainfracao, setdatainfracao] = useState(''); // datetime-local
  const [local, setlocal] = useState('');
  const [infracao, setinfracao] = useState('');
  const [valor, setvalor] = useState(''); // string controlada
  const [dataindicacao, setdataindicacao] = useState(''); // YYYY-MM-DD
  const [natureza, setnatureza] = useState('');
  const [pontuacao, setpontuacao] = useState(''); // string
  const [datacolaborador, setdatacolaborador] = useState('');
  const [statusmulta, setstatusmulta] = useState('');
  const [idsite, setidsite] = useState('');

  const [idempresa, setidempresa] = useState(0);
  const [idpessoa, setidpessoa] = useState(0);

  const [selectedoptionempresa, setselectedoptionempresa] = useState(null);
  const [selectedoptionfuncionario, setselectedoptionfuncionario] = useState(null);

  const [empresalista, setempresalista] = useState([]); // [{value,label}]
  const [funcionariolista, setfuncionariolista] = useState([]); // [{value,label}]

  const [selectedInfracaoOption, setSelectedInfracaoOption] = useState(null);
  const [veiculoslista, setveiculoslista] = useState([]);
  const [departamentolista, setdepartamentolista] = useState([]);

  // nomes vindos do GET (quando idempresa/idpessoa não vierem)
  const [empresaNomeRef, setEmpresaNomeRef] = useState('');
  const [funcionarioNomeRef, setFuncionarioNomeRef] = useState('');

  const params = {
    idcliente: 1,
    idusuario: 1,
    idloja: 1,
    idpessoabusca: ididentificador,
    deletado: 0,
  };

  const togglecadastro = () => {
    setshow(!show);
  };

  const listamultas = async () => {
    try {
      setloading(true);
      const response = await api.get('v1/multasid', { params });
      const { data } = response;

      setidmultas(asStr(data.idmultas));
      setnomeindicado(asUpper(data.nomeindicado || data.funcionario || ''));
      setplaca(asUpper(data.placa));
      setnumeroait(asUpper(data.numeroait));
      // <<< CONVERSÃO ROBUSTA >>>
      setdatainfracao(toDateTimeLocal(asStr(data.datainfracao)));
      setlocal(asUpper(data.local));
      setinfracao(asUpper(data.infracao));

      // usa valordespesa se vier; senão, valor
      const valorBruto = data.valordespesa ?? data.valor;
      setvalor(asNumOrEmpty(valorBruto));

      setdataindicacao(asStr(data.dataindicacao));
      setnatureza(asUpper(data.natureza));
      setpontuacao(asStr(data.pontuacao));
      setdatacolaborador(asStr(data.datacolaborador));
      setstatusmulta(asUpper(data.statusmulta));

      // Departamento/ID Site a partir do rateio
      const { departamento: depFromRateio, idsite: idsiteFromRateio } = pickDepartamentoFromRateio(data.rateio);
      const depFinal = depFromRateio || asStr(data.departamento);
      setdepartamento(depFinal);
      setidsite(depFinal === 'Site' ? asStr(idsiteFromRateio) : '');

      // salva ids (se vierem) e também os nomes para reconciliar depois
      setidempresa(data.idempresa ?? 0);
      setidpessoa(data.idpessoa ?? 0);
      setEmpresaNomeRef(asStr(data.empresa));
      setFuncionarioNomeRef(asStr(data.funcionario));

      // seta selects se já tiver id
      setselectedoptionempresa(
        data.idempresa ? { value: data.idempresa, label: asUpper(data.empresa || '') } : null
      );
      setselectedoptionfuncionario(
        data.idpessoa ? { value: data.idpessoa, label: asUpper(data.funcionario || '') } : null
      );

      // infração -> natureza/pontuação
      const infracaoOption = infracaoOptions.find((option) => option.value === String(data.infracao).toUpperCase());
      setSelectedInfracaoOption(infracaoOption || null);
      if (infracaoOption) {
        setnatureza(infracaoOption.natureza || '');
        setpontuacao(infracaoOption.pontuacao || '');
      }

      setmensagem('');
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  const listaempresa = async () => {
    try {
      setloading(true);
      const response = await api.get('v1/empresas/selectpj', {
        params: { ...params, showinative: 'true' },
      });
      setempresalista(response.data || []);
      setmensagem('');
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  const listafuncionario = async (id) => {
    try {
      setloading(true);
      const response = await api.get(`v1/pessoa/selectfuncionario/${id}`, {
        params: { isOnlyCnh: 1, showinative: 'true' },
      });
      setfuncionariolista(response.data || []);
      setmensagem('');
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  const handleempresa = (opt) => {
    if (opt) {
      setidempresa(opt.value);
      setselectedoptionempresa({ value: opt.value, label: opt.label });
      listafuncionario(opt.value);
    } else {
      setidempresa(0);
      setselectedoptionempresa(null);
      setfuncionariolista([]);
      setselectedoptionfuncionario(null);
      setidpessoa(0);
    }
  };

  const handlefuncionario = (opt) => {
    if (opt) {
      setidpessoa(opt.value);
      setselectedoptionfuncionario({ value: opt.value, label: opt.label });
      setnomeindicado(asUpper(opt.label || ''));
    } else {
      setidpessoa(0);
      setselectedoptionfuncionario(null);
      setnomeindicado('');
    }
  };

  const handleInfracaoChange = (opt) => {
    if (opt) {
      setinfracao(String(opt.value).toUpperCase());
      setSelectedInfracaoOption(opt);
      setnatureza(opt.natureza?.trim() ? opt.natureza : 'NÃO SE APLICA');
      setpontuacao(opt.pontuacao?.trim() ? opt.pontuacao : '0');
    } else {
      setinfracao('');
      setSelectedInfracaoOption(null);
      setnatureza('NÃO SE APLICA');
      setpontuacao('0');
    }
  };

  function ProcessaCadastro(e) {
    e.preventDefault();
    setmensagem('');
    setmensagemsucesso('');

    if (!placa || placa.trim() === '') {
      toast.error('O campo Placa é obrigatório.');
      return;
    }
    if (!datainfracao || datainfracao.trim() === '') {
      toast.error('O campo Data/Hora da Infração é obrigatório.');
      return;
    }
    if (!local || local.trim() === '') {
      toast.error('O campo Local Infração é obrigatório.');
      return;
    }
    if (!infracao) {
      toast.error('O campo Infração é obrigatório.');
      return;
    }
    if (!idempresa) {
      toast.error('Selecione uma Empresa.');
      return;
    }
    if (!idpessoa) {
      toast.error('Selecione um Nome Indicado.');
      return;
    }
    if (!departamento || departamento.trim() === '') {
      toast.error('O campo Departamento é obrigatório.');
      return;
    }
    if (departamento && departamento.toLowerCase() === 'site' && (!idsite || idsite.trim() === '')) {
      toast.error('O campo ID Site é obrigatório quando o Departamento for Site.');
      return;
    }

    const formattedDataindicacao = dataindicacao ? dataindicacao.trim() : '';
    const formattedDatacolaborador = datacolaborador ? datacolaborador.trim() : '';

    // normaliza valor e garante número
    const valorNum = valor === '' ? null : Number(normalizeMoney(valor));

    // monta rateio com 100%
    const rateio =
      departamento === 'Site'
        ? [
          {
            percentual: 100.0,
            tipo: 'SITE',
            idsite: idsite ? idsite.trim() : null,
          },
        ]
        : [
          {
            percentual: 100.0,
            tipo: 'DEPARTAMENTO',
            departamento,
          },
        ];

    const data = {
      idmultas: ididentificador ? parseInt(ididentificador, 10) : null,
      idempresa: idempresa ? parseInt(idempresa, 10) : null,
      idpessoa: idpessoa ? parseInt(idpessoa, 10) : null,
      numeroait: numeroait ? String(numeroait).trim() : null,
      pontuacao: pontuacao ? parseInt(pontuacao, 10) : 0,
      nomeindicado,
      placa,
      // >>> Envia no padrão BR que o backend retornou
      datainfracao: toIsoSqlDatetime(datainfracao),
      local,
      infracao,
      valor: valorNum,        // mantém compatibilidade
      valordespesa: valorNum, // backend de despesas
      dataindicacao: formattedDataindicacao,
      natureza,
      datacolaborador: formattedDatacolaborador,
      statusmulta,
      idcliente: 1,
      idusuario: 1,
      idloja: 1,
      departamento,
      idsite: idsite ? idsite.trim() : null,
      rateio,
    };

    api
      .post('v1/multas', data)
      .then((response) => {
        if (response.status === 201) {
          toast.success('Registro salvo com sucesso!', { autoClose: 2000 });
          setTimeout(() => {
            setshow(false);
            togglecadastro();
            if (typeof atualiza === 'function') atualiza();
          }, 2000);
        } else {
          toast.error(`Erro: ${response.status}`);
        }
      })
      .catch((err) => {
        if (err.response?.data?.erro) {
          toast.error(`Erro: ${err.response.data.erro}`);
        } else {
          toast.error('Erro ao cadastrar a multa. Verifique os campos e tente novamente.');
        }
      });
  }

  const listaveiculos = async () => {
    try {
      setloading(true);
      const response = await api.get('v1/veiculos', { params });
      const lista = (response.data || []).map((item) => ({
        value: item.placa,
        label: item.placa,
        empresaId: item.idempresa,
        pessoaId: item.idpessoa,
      }));
      setveiculoslista(lista);
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  const listadepartamento = () => {
    const lista = DEPARTAMENTOS_TELE_EQUIPE.map((nome) => ({
      label: nome,
      value: nome,
    }));
    setdepartamentolista(lista);
  };

  const handleDepartamentoChange = useCallback((option) => {
    const value = option?.value ?? '';
    setdepartamento(value);
    setidsite((prev) => (value === 'Site' ? prev : ''));
  }, []);

  const departamentoValue = useMemo(() => {
    return departamentolista.find((o) => o.value === departamento) ?? null;
  }, [departamentolista, departamento]);

  const iniciatabelas = () => {
    listaveiculos();
    setidmultas(asStr(ididentificador));
    listamultas();
    listaempresa();
    listadepartamento();
  };

  useEffect(() => {
    if (ididentificador) {
      iniciatabelas();
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [ididentificador]);

  // ========= RECONCILIAÇÃO DE EMPRESA PELO NOME QUANDO NÃO VEM ID =========
  useEffect(() => {
    if (!Array.isArray(empresalista) || empresalista.length === 0) return;

    // 1) tenta pelo id (se existir)
    if (idempresa) {
      const byId = empresalista.find((o) => String(o.value) === String(idempresa));
      if (byId) {
        setselectedoptionempresa(byId);
        return;
      }
    }

    // 2) tenta pelo nome (data.empresa)
    if (empresaNomeRef && !selectedoptionempresa) {
      const target = norm(empresaNomeRef);
      // busca match por igualdade ou inclusão
      const byName =
        empresalista.find((o) => norm(o.label) === target) ||
        empresalista.find((o) => norm(o.label).includes(target)) ||
        empresalista.find((o) => target.includes(norm(o.label)));

      if (byName) {
        setidempresa(byName.value);
        setselectedoptionempresa(byName);
        // carrega funcionários da empresa encontrada
        listafuncionario(byName.value);
      }
    }
  }, [empresalista, idempresa, empresaNomeRef, selectedoptionempresa]);

  // ========= RECONCILIAÇÃO DE FUNCIONÁRIO PELO NOME QUANDO NÃO VEM ID =====
  useEffect(() => {
    if (!Array.isArray(funcionariolista) || funcionariolista.length === 0) return;

    // 1) tenta pelo id (se existir)
    if (idpessoa) {
      const byId = funcionariolista.find((o) => String(o.value) === String(idpessoa));
      if (byId) {
        setselectedoptionfuncionario(byId);
        setnomeindicado(asUpper(byId.label || ''));
        return;
      }
    }

    // 2) tenta pelo nome (data.funcionario)
    if (funcionarioNomeRef && !selectedoptionfuncionario) {
      const target = norm(funcionarioNomeRef);
      const byName =
        funcionariolista.find((o) => norm(o.label) === target) ||
        funcionariolista.find((o) => norm(o.label).includes(target)) ||
        funcionariolista.find((o) => target.includes(norm(o.label)));

      if (byName) {
        setidpessoa(byName.value);
        setselectedoptionfuncionario(byName);
        setnomeindicado(asUpper(byName.label || ''));
      }
    }
  }, [funcionariolista, idpessoa, funcionarioNomeRef, selectedoptionfuncionario]);

  return (
    <>
      <Modal
        isOpen={show}
        toggle={togglecadastro}
        backdrop="static"
        keyboard={false}
        fade={false}
        className="modal-dialog modal-xl modal-fullscreen"
      >
        <ModalHeader toggle={togglecadastro} className="h1 fw-bold">
          Multas
        </ModalHeader>
        <ModalBody>
          {mensagem && (
            <div className="alert alert-danger mt-2" role="alert">
              {mensagem}
            </div>
          )}
          {mensagemsucesso && (
            <div className="alert alert-success" role="alert">
              Registro Salvo
            </div>
          )}
          {telaexclusao && (
            <Excluirregistro
              show={telaexclusao}
              setshow={settelaexclusao}
              ididentificador={ididentificador}
              quemchamou="PESSOAS"
            />
          )}
          {loading ? (
            <Loader />
          ) : (
            <div className="row g-6">
              <Col md="4">
                Placa
                <Select
                  isClearable
                  isSearchable
                  name="veiculo"
                  options={veiculoslista}
                  placeholder="Selecione"
                  isLoading={loading}
                  onChange={(opt) => setplaca(opt ? opt.value : '')}
                  value={veiculoslista.find((v) => v.value === placa) || null}
                />
              </Col>

              <Col md="4">
                <FormGroup>
                  Data/Hora da Infração
                  <Input
                    type="datetime-local"
                    step="60"
                    onChange={(e) => setdatainfracao(e.target.value)}
                    value={datainfracao ?? ''}
                    placeholder=""
                  />
                </FormGroup>
              </Col>

              <Col md="4">
                <FormGroup>
                  <Input
                    type="hidden"
                    onChange={(e) => setidmultas(e.target.value)}
                    value={idmultas ?? ''}
                    placeholder=""
                  />
                  Número AIT
                  <Input
                    type="text"
                    onChange={(e) => setnumeroait(asUpper(e.target.value))}
                    value={numeroait ?? ''}
                    placeholder=""
                  />
                </FormGroup>
              </Col>

              <div className="col-sm-6" style={{ marginBottom: '20px' }}>
                Empresa
                <Select
                  isClearable
                  isSearchable
                  name="empresa"
                  options={empresalista}
                  placeholder="Selecione"
                  isLoading={loading}
                  onChange={handleempresa}
                  value={selectedoptionempresa}
                />
              </div>

              <div className="col-sm-6">
                Nome do Indicado
                <Select
                  isClearable
                  isSearchable
                  name="funcionario"
                  options={Array.isArray(funcionariolista) ? funcionariolista : []}
                  placeholder="Selecione"
                  isLoading={loading}
                  onChange={handlefuncionario}
                  value={selectedoptionfuncionario}
                />
              </div>

              <Col md="12">
                <FormGroup>
                  Infração
                  <Select
                    isClearable
                    isSearchable
                    name="infracao"
                    options={infracaoOptions}
                    placeholder="Selecione"
                    onChange={handleInfracaoChange}
                    value={selectedInfracaoOption}
                  />
                </FormGroup>
              </Col>

              <Col md="12">
                <FormGroup>
                  Local Infração
                  <Input
                    type="text"
                    onChange={(e) => setlocal(asUpper(e.target.value))}
                    value={local ?? ''}
                    placeholder=""
                  />
                </FormGroup>
              </Col>

              <Col md="2">
                <FormGroup>
                  Valor
                  <Input
                    type="number"
                    onChange={(e) => {
                      const v = e.target.value; // string
                      setvalor(v); // manter como string controlada; converter no submit
                    }}
                    value={valor === '' ? '' : valor}
                    placeholder=""
                  />
                </FormGroup>
              </Col>

              <Col md="2">
                <FormGroup>
                  Pontuação
                  <Input type="text" value={pontuacao ?? ''} placeholder="" readOnly />
                </FormGroup>
              </Col>

              <Col md="8">
                <FormGroup>
                  Natureza
                  <Input type="text" value={asUpper(natureza)} placeholder="" readOnly />
                </FormGroup>
              </Col>

              <Col md="6">
                <FormGroup>
                  Status
                  <Input
                    type="text"
                    onChange={(e) => setstatusmulta(asUpper(e.target.value))}
                    value={statusmulta ?? ''}
                  />
                </FormGroup>
              </Col>

              <Col md="3">
                <FormGroup>
                  Data Limite para Indicação
                  <Input
                    type="date"
                    onChange={(e) => setdataindicacao(e.target.value)}
                    value={dataindicacao ?? ''}
                    placeholder=""
                  />
                </FormGroup>
              </Col>

              <Col md="3">
                <FormGroup>
                  Data Envio para Colaborador
                  <Input
                    type="date"
                    onChange={(e) => setdatacolaborador(e.target.value)}
                    value={datacolaborador ?? ''}
                    placeholder=""
                  />
                </FormGroup>
              </Col>

              <Col md="6">
                Departamento
                <Select
                  isClearable
                  isSearchable
                  name="departamento"
                  options={departamentolista}
                  placeholder="Selecione"
                  isLoading={loading}
                  onChange={handleDepartamentoChange}
                  value={departamentoValue}
                />
              </Col>

              {departamento === 'Site' && (
                <Col md="6">
                  <FormGroup>
                    ID do Site
                    <Input
                      type="text"
                      onChange={(e) => setidsite(asUpper(e.target.value))}
                      value={idsite ?? ''}
                    />
                  </FormGroup>
                </Col>
              )}
            </div>
          )}
        </ModalBody>
        <ModalFooter>
          <Button color="success" onClick={ProcessaCadastro} disabled={modoVisualizador()}>
            Salvar
          </Button>
          <Button color="secondary" onClick={togglecadastro}>
            Sair
          </Button>
        </ModalFooter>
      </Modal>

      <ToastContainer
        position="top-right"
        autoClose={5000}
        hideProgressBar={false}
        newestOnTop={false}
        closeOnClick
        rtl={false}
        pauseOnFocusLoss
        draggable
        pauseOnHover
        containerStyle={{ zIndex: 99999 }}
      />
    </>
  );
};

Multasedicao.propTypes = {
  show: PropTypes.bool.isRequired,
  setshow: PropTypes.func.isRequired,
  ididentificador: PropTypes.number,
  atualiza: PropTypes.func, // corrigido
};

export default Multasedicao;
