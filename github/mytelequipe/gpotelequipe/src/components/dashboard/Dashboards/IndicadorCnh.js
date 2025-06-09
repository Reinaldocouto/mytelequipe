import React, { useState, useEffect } from 'react';
import Chart from 'react-apexcharts';
import { Button, Col, Row } from 'reactstrap';
import DashCard from '../dashboardCards/DashCard';
import api from '../../../services/api';
import Loader from '../../../layouts/loader/Loader';
import CnhModal from './CnhModal';

const IndicadorCnh = () => {
  const [loading, setLoading] = useState(true);
  const [series, setSeries] = useState([]);
  const [totalCount, setTotalCount] = useState(0);
  const [cnhVencida, setCnhVencida] = useState([]);
  const [cnhAVencer, setCnhAVencer] = useState([]);
  const [cnhValida, setCnhValida] = useState([]);
  const [porcentagemValidos, setPorcentagemValidos] = useState(0);
  const [isOpen, setIsOpen] = useState(false);
  const [modalData, setModalData] = useState([]);
  const [modalTitle, setModalTitle] = useState('');

  const toggleModal = () => setIsOpen(!isOpen);

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
      const veiculosAtivos = response.data.filter(v => v.status === 'ATIVO' && v.statuspessoa === 'ATIVO');

      const cnhVencidaData = veiculosAtivos.filter(v => v.datavalidadecnh && new Date(v.datavalidadecnh) < new Date());
      const cnhAVencerData = veiculosAtivos.filter(v => v.datavalidadecnh && new Date(v.datavalidadecnh) >= new Date() && new Date(v.datavalidadecnh) <= new Date(new Date().setDate(new Date().getDate() + 30)));
      const cnhValidaData = veiculosAtivos.filter(v => v.datavalidadecnh && new Date(v.datavalidadecnh) > new Date(new Date().setDate(new Date().getDate() + 30)));

      setCnhVencida(cnhVencidaData);
      setCnhAVencer(cnhAVencerData);
      setCnhValida(cnhValidaData);

      const total = cnhVencidaData.length + cnhAVencerData.length + cnhValidaData.length;
      setTotalCount(total);
      setPorcentagemValidos(total > 0 ? (cnhValidaData.length / total) * 100 : 0);

      setSeries([
        cnhVencidaData.length,
        cnhAVencerData.length,
        cnhValidaData.length,
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

  const handleLegendClick = (status) => {
    let data = [];
    let title = '';
    switch (status) {
      case 'Válidas':
        data = cnhValida;
        title = 'CNHs Válidas';
        break;
      case 'A Vencer':
        data = cnhAVencer;
        title = 'CNHs a Vencer';
        break;
      case 'Vencidas':
        data = cnhVencida;
        title = 'CNHs Vencidas';
        break;
      default:
        break;
    }
    setModalData(data);
    setModalTitle(title);
    setIsOpen(true);
  };

  const options = {
    labels: ['CNH Vencida', 'CNH a Vencer', 'CNH Válida'],
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
      <DashCard title="Veículos - Validade CNH">
        <Row className="mt-4">
          <Col md="7">
            <div style={{ height: '250px' }}>
              <Chart options={options} series={series} type="donut" height="250" />
            </div>
          </Col>
          <Col md="5">
            <h2 className="mb-1 mt-3 fs-1">{Number(porcentagemValidos).toFixed(2)} %</h2>
            <span className="text-muted">{totalCount} CNHs com veículos</span>
            <div className="vstack gap-3 mt-4 pt-1 justify-content-center">
              <div className="d-flex align-items-center">
                <i className="bi bi-circle-fill fs-6 me-2" style={{ color: '#007bff' }}></i>
                <Button color='white' onClick={() => handleLegendClick('Válidas')} className="uniform-button">Válidas</Button>
              </div>
              <div className="d-flex align-items-center">
                <i className="bi bi-circle-fill fs-6 me-2 text-warning"></i>
                <Button color='white' onClick={() => handleLegendClick('A Vencer')} className="uniform-button">A Vencer</Button>
              </div>
              <div className="d-flex align-items-center">
                <i className="bi bi-circle-fill fs-6 me-2 text-danger"></i>
                <Button color='white' onClick={() => handleLegendClick('Vencidas')} className="uniform-button">Vencidas</Button>
              </div>
            </div>
          </Col>
        </Row>
      </DashCard>

      <CnhModal isOpen={isOpen} toggle={toggleModal} data={modalData} title={modalTitle} />
    </>
  );
};

export default IndicadorCnh;