import React, { useEffect, useCallback, useState } from 'react';
import Chart from 'react-apexcharts';
import { Button, Col, Row } from 'reactstrap';
import DashCard from '../dashboardCards/DashCard';
import '../modernDashboard/SalesMonth.scss';
import api from '../../../services/api';
import Loader from '../../../layouts/loader/Loader';
import exportExcel from '../../../data/exportexcel/Excelexport';
import TreinamentoModal from '../../formulario/cadastro/TreinamentoModal';

const Treinamentos = () => {
  const [loading, setLoading] = useState(true);
  const [treinamentosValidos, setTreinamentosValidos] = useState([]);
  const [treinamentosVencidos, setTreinamentosVencidos] = useState([]);
  const [treinamentosAVencer, setTreinamentosAVencer] = useState([]);
  const [totalTreinamentos, setTotalTreinamentos] = useState();
  const [listaTreinamentos, setListaTreinamentos] = useState([]);
  const [porcetagemValidos, setPorcentagemValidos] = useState();
  const [modalOpen, setModalOpen] = useState(false);  // Estado para controle do modal
  const [modalData, setModalData] = useState([]);  // Dados para o modal
  const [modalTitle, setModalTitle] = useState('');  // Título do modal

  const calcularPorcentagemValidos = (qtdTotalTreinamento, totalValidos) => {
    const porcetagem = (totalValidos / qtdTotalTreinamento) * 100;
    setPorcentagemValidos(porcetagem);
  };

  const params = {
    busca: '',
    idcliente: localStorage.getItem('sessionCodidcliente'),
    idusuario: localStorage.getItem('sessionId'),
    idloja: localStorage.getItem('sessionloja'),
    deletado: 0,
  };

  const optionsSales = {
    labels: ['Válidos', 'A vencer', 'Vencidos'],
    chart: {
      fontFamily: "'Rubik', sans-serif",
    },
    dataLabels: {
      enabled: true,
      formatter: (val) => `${val.toFixed(1)}%`, // Exibe as porcentagens com duas casas decimais
      dropShadow: {
        enabled: false,
      },
    },
    grid: {
      borderColor: 'rgba(0,0,0,0.2)',
      padding: {
        left: 0,
        right: 0,
      },
    },
    plotOptions: {
      pie: {
        donut: {
          size: '68%', // Tamanho do donut
        },
      },
    },
    stroke: {
      width: 2,
      colors: ['#fff'],
    },
    legend: {
      show: false,
      labels: {
        colors: 'red',
      },
    },
    colors: ['#007bff', '#FFA500', '#FF0000'],  // Válidos, A vencer, Vencidos
    tooltip: {
      fillSeriesColor: false,
    },
  };

  const seriesTreinamento = [
    treinamentosValidos.length,
    treinamentosAVencer.length,
    treinamentosVencidos.length,
  ];

  const treinamentos = useCallback(async () => {
    try {
        const response = await api.get('v1/pessoa/treinamentogeral', {
            params,
        });
        if (response.status === 200) {
          //console.log("o que vem em vi/pessoa/treinamentogeral: ", response.data);
            const { data } = response;
            const now = new Date();
            const nowTimestamp = now.getTime();
            const in30DaysTimestamp = new Date(now.getTime() + 30 * 24 * 60 * 60 * 1000).getTime();
            setTotalTreinamentos(data.length);
            const parseDate = (dateString) => {
                if (!dateString) return null; // Handle null or undefined date strings
                const [day, month, year] = dateString.split('/');
                return new Date(`${year}-${month}-${day}`);
            };

            const within30Days = [];
            const validData = [];
            const expiredData = [];
            setListaTreinamentos(data);
            data.forEach((item) => {
                if (item.status === "INATIVO") return; // não carrega os usuarios inativos

                const vencimentoDate = parseDate(item.datavencimento);
                if (!vencimentoDate) return;

                const vencimentoTimestamp = vencimentoDate.getTime();

                if (vencimentoTimestamp >= nowTimestamp && vencimentoTimestamp <= in30DaysTimestamp) {
                    within30Days.push(item);
                } else if (vencimentoTimestamp > in30DaysTimestamp) {
                    validData.push(item);
                } else if (vencimentoTimestamp < nowTimestamp) {
                    expiredData.push(item);
                }
            });
            calcularPorcentagemValidos(data.length, validData.length);
            setTreinamentosValidos(validData);
            setTreinamentosVencidos(expiredData);
            setTreinamentosAVencer(within30Days);
            setLoading(false);
        }
    } catch (err) {
        console.log(err);
        if (err.response) {
            console.log(err.response.data.erro);
        } else {
            console.log('Ocorreu um erro na requisição.');
        }
    }
}, [params]);

  const gerarexcel = () => {
    if (listaTreinamentos.length === 0) {
      return;
    }
    const excelData = listaTreinamentos.map((item) => {
      return {
        Nome: item.nome,
        'Data de emissão': item.dataemissao,
        'Id treinamento': item.idtreinamento,
        'Data de vencimento': item.datavencimento,
        Descrição: item.descricao,
        Situação: item.situacao,
      };
    });
    exportExcel({ excelData, fileName: 'Treinamento Geral' });
  };

  const showModal = (status) => {
    let data = [];
    let title = '';
    if (status === 'Válidos') {
      data = treinamentosValidos;
      title = 'Treinamentos Válidos';
    } else if (status === 'A vencer') {
      data = treinamentosAVencer;
      title = 'Treinamentos A Vencer';
    } else if (status === 'Vencidos') {
      data = treinamentosVencidos;
      title = 'Treinamentos Vencidos';
    }
    setModalData(data);
    setModalTitle(title);
    setModalOpen(true);
  };

  useEffect(() => {
    treinamentos();
  }, [treinamentos]);

  return loading ? (
    <Loader />
  ) : (
    <>
      <DashCard
        title="Treinamentos"
        actions={
          <Button color="link" onClick={() => gerarexcel()}>
            Exportar Excel
          </Button>
        }
      >
        <Row className="mt-4">
          <Col md="7">
            <div className="mt-3 position-relative" style={{ height: '250px' }}>
              <Chart options={optionsSales} series={seriesTreinamento} type="donut" height="250" />
            </div>
          </Col>
          <Col md="5">
            <h2 className="mb-1 mt-3 fs-1">{Number(porcetagemValidos).toFixed(2)} %</h2>
            <span className="text-muted">{totalTreinamentos} Treinamentos</span>
            <div className="vstack gap-3 mt-4 pt-1 justify-content-center">
              <div className="d-flex align-items-center">
                <i className="bi bi-circle-fill fs-6 me-2" style={{ color: '#007bff' }}></i>                
                <Button color='white' onClick={() => showModal('Válidos')} className="uniform-button">Válidos</Button>
              </div>
              <div className="d-flex align-items-center">
                <i className="bi bi-circle-fill fs-6 me-2 text-warning"></i>
                <Button color='white' onClick={() => showModal('A vencer')} className="uniform-button">A vencer</Button>
              </div>
              <div className="d-flex align-items-center">
                <i className="bi bi-circle-fill fs-6 me-2 text-danger"></i>
                <Button color='white' onClick={() => showModal('Vencidos')} className="uniform-button">Vencidos</Button>
              </div>
            </div>

          </Col>
        </Row>
      </DashCard>
      <TreinamentoModal isOpen={modalOpen} toggle={() => setModalOpen(false)} data={modalData} title={modalTitle} />
    </>
  );
};

export default React.memo(Treinamentos);