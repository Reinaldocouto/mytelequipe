import { useState, useEffect } from 'react';
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

// Função auxiliar para converter o valor do campo datetime-local (ex.: "2024-11-22T08:20")
// para o formato esperado pelo back-end ("YYYY-MM-DD HH:MM:SS")
/*const convertDatetimeLocalToMySQL = (datetimeLocalValue) => {
  if (!datetimeLocalValue) return '';
  // Substitui o "T" por espaço e acrescenta ":00" para os segundos
  return `${datetimeLocalValue.replace('T', ' ')}:00`;
};  */

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
6009\tExecutar operação de retorno nas curvas - Executar operação de retorno nos aclives ou declives - Executar operação de retorno nas pontes - Executar operação de retorno nos viadutos - Executar operação de retorno nos túneis 
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
  const [idmultas, setidmultas] = useState();
  const [nomeindicado, setnomeindicado] = useState('');
  const [placa, setplaca] = useState('');
  const [numeroait, setnumeroait] = useState('');
  const [datainfracao, setdatainfracao] = useState('');
  const [local, setlocal] = useState('');
  const [infracao, setinfracao] = useState('');
  const [valor, setvalor] = useState('');
  const [dataindicacao, setdataindicacao] = useState('');
  const [natureza, setnatureza] = useState('');
  const [pontuacao, setpontuacao] = useState('');
  const [datacolaborador, setdatacolaborador] = useState('');
  const [statusmulta, setstatusmulta] = useState('');
  const [idempresa, setidempresa] = useState('');
  const [idpessoa, setidpessoa] = useState('');
  const [selectedoptionempresa, setselectedoptionempresa] = useState(null);
  const [selectedoptionfuncionario, setselectedoptionfuncionario] = useState(null);
  const [empresalista, setempresalista] = useState('');
  const [funcionariolista, setfuncionariolista] = useState('');
  const [selectedInfracaoOption, setSelectedInfracaoOption] = useState(null);
  const [veiculoslista, setveiculoslista] = useState([]);

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
      await api.get('v1/multasid', { params }).then((response) => {
        const { data } = response;
        setidmultas(data.idmultas);
        setnomeindicado(data.nomeindicado);
        setplaca(data.placa ? data.placa.toUpperCase() : '');
        setnumeroait(data.numeroait ? data.numeroait.toUpperCase() : '');
        setdatainfracao(data.datainfracao);
        setlocal(data.local ? data.local.toUpperCase() : '');
        setinfracao(data.infracao ? data.infracao.toUpperCase() : '');
        setvalor(data.valor);
        setdataindicacao(data.dataindicacao);
        setnatureza(data.natureza ? data.natureza.toUpperCase() : '');
        setpontuacao(data.pontuacao);
        setdatacolaborador(data.datacolaborador ? data.datacolaborador.toUpperCase() : '');
        setstatusmulta(data.statusmulta ? data.statusmulta.toUpperCase() : '');
        setselectedoptionempresa({
          value: data.idempresa,
          label: data.empresa ? data.empresa.toUpperCase() : '',
        });
        setselectedoptionfuncionario({
          value: data.idpessoa,
          label: data.funcionario ? data.funcionario.toUpperCase() : '',
        });
        setidempresa(data.idempresa);
        setidpessoa(data.idpessoa);
        const infracaoOption = infracaoOptions.find((option) => option.value === data.infracao);
        setSelectedInfracaoOption(infracaoOption);
        if (infracaoOption) {
          setnatureza(infracaoOption.natureza || '');
          setpontuacao(infracaoOption.pontuacao || '');
        }
        setmensagem('');
      });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  const listaempresa = async () => {
    try {
      setloading(true);
      await api
        .get('v1/empresas/selectpj', {
          params: { ...params, showinative: 'true' },
        })
        .then((response) => {
          setempresalista(response.data);
          setmensagem('');
        });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  const listafuncionario = async (id) => {
    try {
      setloading(true);
      console.log('Funcionario');
      await api
        .get(`v1/pessoa/selectfuncionario/${id}`, {
          params: { isOnlyCnh: 1, showinative: 'true' },
        })
        .then((response) => {
          console.log(response);
          setfuncionariolista(response.data);
          setmensagem('');
        });
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };

  const handleempresa = (stat) => {
    if (stat !== null) {
      setidempresa(stat.value);
      setselectedoptionempresa({ value: stat.value, label: stat.label });
      listafuncionario(stat.value);
    } else {
      setidempresa(0);
      setselectedoptionempresa({ value: null, label: null });
    }
  };

  const handlefuncionario = (stat) => {
    if (stat !== null) {
      setidpessoa(stat.value);
      setselectedoptionfuncionario({ value: stat.value, label: stat.label });
    } else {
      setidpessoa(0);
      setselectedoptionfuncionario({ value: null, label: null });
    }
  };

  const handleInfracaoChange = (option) => {
    if (option) {
      setinfracao(option.value.toUpperCase());
      setSelectedInfracaoOption(option);
      setnatureza(
        option.natureza && option.natureza.trim() !== '' ? option.natureza : 'NÃO SE APLICA',
      );
      setpontuacao(option.pontuacao && option.pontuacao.trim() !== '' ? option.pontuacao : '0');
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

    // Validações dos campos
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
    /*if (!dataindicacao || dataindicacao.trim() === '') {
      toast.error('O campo Data Limite para Indicação é obrigatório.');
      return;
    }
    if (!datacolaborador || datacolaborador.trim() === '') {
      toast.error('O campo Data Envio para Colaborador é obrigatório.');
      return;
    }*/
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

    // Converte datainfracao para o formato "YYYY-MM-DD HH:MM:SS"
    //const formattedDatainfracao = convertDatetimeLocalToMySQL(datainfracao);
    const formattedDataindicacao = dataindicacao ? dataindicacao.trim() : '';
    const formattedDatacolaborador = datacolaborador ? datacolaborador.trim() : '';

    const data = {
      idmultas: ididentificador ? parseInt(ididentificador, 10) : null,
      idempresa: idempresa ? parseInt(idempresa, 10) : null,
      idpessoa: idpessoa ? parseInt(idpessoa, 10) : null,
      numeroait: numeroait ? String(numeroait).trim() : null,
      pontuacao: pontuacao ? parseInt(pontuacao, 10) : 0,
      nomeindicado,
      placa,
      datainfracao, //   :   formattedDatainfracao,
      local,
      infracao,
      valor,
      dataindicacao: formattedDataindicacao,
      natureza,
      datacolaborador: formattedDatacolaborador,
      statusmulta,
      idcliente: 1,
      idusuario: 1,
      idloja: 1,
    };

    api
      .post('v1/multas', data)
      .then((response) => {
        if (response.status === 201) {
          toast.success('Registro salvo com sucesso!', { autoClose: 2000 });

          // Adiar fechamento da modal para garantir que o toast seja exibido
          setTimeout(() => {
            setshow(false);
            togglecadastro();
            atualiza(); // Se `atualiza` recarregar algo, ele virá depois do toast.
          }, 2000); // Espera 2 segundos antes de fechar a modal
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
      //console.log("get de veiculos: ", response.data);
      const lista = response.data.map((item) => {
        return {
          value: item.placa,
          label: item.placa,
          empresaId: item.idempresa,
          pessoaId: item.idpessoa,
        };
      });
      setveiculoslista(lista);
    } catch (err) {
      setmensagem(err.message);
    } finally {
      setloading(false);
    }
  };
  const iniciatabelas = () => {
    listaveiculos();
    setidmultas(ididentificador);
    listamultas();
    listaempresa();
  };

  useEffect(() => {
    if (ididentificador) {
      iniciatabelas();
    }
  }, [ididentificador]);

  return (
    <>
      <Modal
        isOpen={show}
        toggle={togglecadastro}
        backdrop="static"
        keyboard={false}
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
                  onChange={(e) => setplaca(e.value)}
                  value={veiculoslista.find((v) => v.value === placa) || null}
                />
              </Col>

              <Col md="4">
                <FormGroup>
                  Data/Hora da Infração
                  <Input
                    type="datetime-local"
                    onChange={(e) => setdatainfracao(e.target.value)}
                    value={datainfracao}
                    placeholder=""
                  />
                </FormGroup>
              </Col>

              <Col md="4">
                <FormGroup>
                  <Input
                    type="hidden"
                    onChange={(e) => setidmultas(e.target.value.toUpperCase())}
                    value={idmultas}
                    placeholder=""
                  />
                  Número AIT
                  <Input
                    type="text"
                    onChange={(e) => setnumeroait(e.target.value.toUpperCase())}
                    value={numeroait}
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
                    onChange={(e) => setlocal(e.target.value.toUpperCase())}
                    value={local}
                    placeholder=""
                  />
                </FormGroup>
              </Col>

              <Col md="2">
                <FormGroup>
                  Valor
                  <Input
                    type="number"
                    onChange={(e) => setvalor(e.target.value.toUpperCase())}
                    value={valor}
                    placeholder=""
                  />
                </FormGroup>
              </Col>

              <Col md="2">
                <FormGroup>
                  Pontuação
                  <Input type="text" value={pontuacao} placeholder="" readOnly />
                </FormGroup>
              </Col>

              <Col md="8">
                <FormGroup>
                  Natureza
                  <Input type="text" value={natureza.toUpperCase()} placeholder="" readOnly />
                </FormGroup>
              </Col>

              <Col md="6">
                <FormGroup>
                  Status
                  <Input
                    type="text"
                    onChange={(e) => setstatusmulta(e.target.value.toUpperCase())}
                    value={statusmulta}
                  />
                </FormGroup>
              </Col>

              <Col md="3">
                <FormGroup>
                  Data Limite para Indicação
                  <Input
                    type="date"
                    onChange={(e) => setdataindicacao(e.target.value)}
                    value={dataindicacao}
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
                    value={datacolaborador}
                    placeholder=""
                  />
                </FormGroup>
              </Col>
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
  atualiza: PropTypes.node,
};

export default Multasedicao;
