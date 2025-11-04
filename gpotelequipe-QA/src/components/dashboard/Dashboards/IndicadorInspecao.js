import React, { useState, useEffect } from 'react';
import Chart from 'react-apexcharts';
import { Button, Col, Row } from 'reactstrap';
import DashCard from '../dashboardCards/DashCard';
import api from '../../../services/api';
import Loader from '../../../layouts/loader/Loader';
import InspecaoModal from './InspecaoModal';

const IndicadorInspecao = () => {
  const [loading, setLoading] = useState(true);
  const [series, setSeries] = useState([]);
  const [totalCount, setTotalCount] = useState(0);
  const [inspecaoVencida, setInspecaoVencida] = useState([]);
  const [inspecaoAVencer, setInspecaoAVencer] = useState([]);
  const [inspecaoValida, setInspecaoValida] = useState([]);
  const [porcentagemValidos, setPorcentagemValidos] = useState(0);

  const [modalOpen, setModalOpen] = useState(false);
  const [modalData, setModalData] = useState([]);
  const [modalTitle, setModalTitle] = useState('');

  const listaveiculos = async () => {
    const params = {
      busca: '',
      idcliente: localStorage.getItem('sessionCodidcliente'),
      idusuario: localStorage.getItem('sessionId'),
      idloja: localStorage.getItem('sessionloja'),
      deletado: 0,
    };
  
    try {
      setLoading(true);
      const response = await api.get('/v1/veiculos', { params });
      //console.log('O que vem em inspecao periodica: ', response.data);
  
      const veiculosAtivos = response.data.filter(v => v.status === 'ATIVO');
  
      const inspecaoVencidaData = veiculosAtivos.filter(v => {
        if (v.inspecaoveicular) {
          const inspecaoDate = new Date(v.inspecaoveicular);
          const vencimentoDate = new Date(inspecaoDate.setMonth(inspecaoDate.getMonth() + 6));
          return new Date() > vencimentoDate;
        }
        return true;
      });
  
      const inspecaoAVencerData = veiculosAtivos.filter(v => {
        if (v.inspecaoveicular) {
          const inspecaoDate = new Date(v.inspecaoveicular);
          const vencimentoDate = new Date(inspecaoDate.setMonth(inspecaoDate.getMonth() + 6));
          const quinzeDiasAntes = new Date(vencimentoDate.setDate(vencimentoDate.getDate() - 15));
          return new Date() >= quinzeDiasAntes && new Date() <= vencimentoDate;
        }
        return false;
      });
  
      const inspecaoValidaData = veiculosAtivos.filter(v => {
        if (v.inspecaoveicular) {
          const inspecaoDate = new Date(v.inspecaoveicular);
          const vencimentoDate = new Date(inspecaoDate.setMonth(inspecaoDate.getMonth() + 6));
          const quinzeDiasAntes = new Date(vencimentoDate.setDate(vencimentoDate.getDate() - 15));
          return new Date() < quinzeDiasAntes;
        }
        return false;
      });
  
      setInspecaoVencida(inspecaoVencidaData);
      setInspecaoAVencer(inspecaoAVencerData);
      setInspecaoValida(inspecaoValidaData);
  
      const total = inspecaoVencidaData.length + inspecaoAVencerData.length + inspecaoValidaData.length;
      setTotalCount(total);
      setPorcentagemValidos(total > 0 ? (inspecaoValidaData.length / total) * 100 : 0);
  
      setSeries([
        inspecaoVencidaData.length,
        inspecaoAVencerData.length,
        inspecaoValidaData.length,
      ]);
    } catch (err) {
      console.error('Erro ao buscar veículos:', err.message);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    listaveiculos();
  }, []);

  const openModal = (title, data) => {
    setModalTitle(title);
    setModalData(data);
    setModalOpen(true);
  };

  const options = {
    labels: ['Inspeção Vencida', 'Inspeção a Vencer', 'Inspeção Válida'],
    chart: {
      type: 'donut',
    },
    colors: ['#FF0000', '#FFA500', '#007bff'],
    legend: {
      show: false,
    },
    dataLabels: {
      enabled: true,
    },
  };

  if (loading) {
    return <Loader />;
  }

  return (
    <>
      <DashCard title="Veículos - Inspeção Veicular">
        <Row className="mt-4">
          <Col md="7">
            <div style={{ height: '250px' }}>
              <Chart options={options} series={series} type="donut" height="250" />
            </div>
          </Col>
          <Col md="5">
            <h2 className="mb-1 mt-3 fs-1">{Number(porcentagemValidos).toFixed(2)} %</h2>
            <span className="text-muted">{totalCount} Veículos</span>
            <div className="vstack gap-3 mt-4 pt-1 justify-content-center">
              <div className="d-flex align-items-center">
              <i className="bi bi-circle-fill fs-6 me-2" style={{ color: '#007bff' }}></i>
                <Button color='white' onClick={() => openModal('Inspeções Válidas', inspecaoValida)} className="uniform-button">Válidas</Button>
              </div>
              <div className="d-flex align-items-center">
                <i className="bi bi-circle-fill fs-6 me-2 text-warning"></i>
                <Button color='white' onClick={() => openModal('Inspeções a Vencer', inspecaoAVencer)} className="uniform-button">A Vencer</Button>
              </div>
              <div className="d-flex align-items-center">
                <i className="bi bi-circle-fill fs-6 me-2 text-danger"></i>
                <Button color='white' onClick={() => openModal('Inspeções Vencidas', inspecaoVencida)} className="uniform-button">Vencida</Button>
              </div>
            </div>
          </Col>
        </Row>
      </DashCard>

      {/* Modal de Inspeção */}
      <InspecaoModal
        isOpen={modalOpen}
        toggle={() => setModalOpen(!modalOpen)}
        data={modalData}
        title={modalTitle}
      />
    </>
  );
};

export default IndicadorInspecao;
