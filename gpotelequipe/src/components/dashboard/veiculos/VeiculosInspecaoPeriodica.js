import React, { useState, useEffect } from 'react';
import Chart from 'react-apexcharts';
import { Button, Col, Row } from 'reactstrap';
import DashCard from '../dashboardCards/DashCard';
import api from '../../../services/api';
import Loader from '../../../layouts/loader/Loader';
import InspecaoPeriodicaModal from './inpecaoPeriodicaModal';

const VeiculosInspecaoPeriodica = () => {
  const [veiculos, setVeiculos] = useState([]);
  const [loading, setLoading] = useState(true);
  const [totalCount, setTotalCount] = useState(0);
  const [porcentagemAtivos, setPorcentagemAtivos] = useState(0);

  const [modalOpen, setModalOpen] = useState(false);
  const [modalData, setModalData] = useState([]);
  const [modalTitle, setModalTitle] = useState('');
  const [originalData, setOriginalData] = useState({});

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
      console.log('grafico dos veiculos por inspeção periodica: ', response.data);

      const veiculosAtivos = response.data.filter(v => v.status === 'ATIVO');
      setVeiculos(veiculosAtivos);

      const ativos = veiculosAtivos.filter(v => parseInt(v.kmsrestante, 10) > 1000).length;
      const totalComCategoria = veiculosAtivos.filter(vei => vei.categoria);

      setTotalCount(totalComCategoria.length);
      setPorcentagemAtivos(totalComCategoria.length > 0 ? (ativos / totalComCategoria.length) * 100 : 0);

      const originalDataMap = {};
      veiculosAtivos.forEach(v => {
        originalDataMap[v.id] = { status: v.status, inspecaoveicular: v.inspecaoveicular };
      });
      setOriginalData(originalDataMap);
    } catch (err) {
      console.error('Erro ao buscar veículos: ', err.message);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    listaveiculos();
  }, []);

  const refreshData = () => {
    listaveiculos();
  };

  const getStatusCount = (categoria, status) => {
    return veiculos.filter(v => {
      const kmsrestante = parseInt(v.kmsrestante, 10);
      return v.categoria && v.categoria.toLowerCase() === categoria.toLowerCase() && (
        (status === 'Ativo' && kmsrestante > 1000) ||
        (status === 'A vencer' && kmsrestante > 0 && kmsrestante <= 1000) ||
        (status === 'Irregular' && kmsrestante <= 0)
      );
    }).length;
  };

  const openModal = (title, data) => {
    setModalTitle(title);
    setModalData(data);
    setModalOpen(true);
  };

  const series = [
    {
      name: 'Ativo',
      data: [
        getStatusCount('Proprio', 'Ativo'),
        getStatusCount('Prestador', 'Ativo'),
        getStatusCount('Unidas', 'Ativo'),
        getStatusCount('Movida', 'Ativo'),
        getStatusCount('Localiza', 'Ativo'),
        getStatusCount('Outros', 'Ativo')
      ],
      color: '#007bff',
    },
    {
      name: 'A vencer',
      data: [
        getStatusCount('Proprio', 'A vencer'),
        getStatusCount('Prestador', 'A vencer'),
        getStatusCount('Unidas', 'A vencer'),
        getStatusCount('Movida', 'A vencer'),
        getStatusCount('Localiza', 'A vencer'),
        getStatusCount('Outros', 'A vencer')
      ],
      color: '#FFA500',
    },
    {
      name: 'Irregular',
      data: [
        getStatusCount('Proprio', 'Irregular'),
        getStatusCount('Prestador', 'Irregular'),
        getStatusCount('Unidas', 'Irregular'),
        getStatusCount('Movida', 'Irregular'),
        getStatusCount('Localiza', 'Irregular'),
        getStatusCount('Outros', 'Irregular')
      ],
      color: '#FF0000',
    },
  ];

  const options = {
    chart: {
      type: 'bar',
      stacked: true,
      toolbar: {
        show: false,
      },
    },
    plotOptions: {
      bar: {
        horizontal: false,
      },
    },
    xaxis: {
      categories: ['Proprio', 'Prestador', 'Unidas', 'Movida', 'Localiza', 'Outros'],
      labels: {
        style: {
          colors: '#99abb4',
          fontSize: '12px',
        },
      },
    },
    yaxis: {
      labels: {
        style: {
          colors: '#99abb4',
          fontSize: '12px',
        },
      },
    },
    legend: {
      show: false,
    },
    grid: {
      borderColor: 'rgba(0,0,0,0.2)',
      strokeDashArray: 2,
    },
    tooltip: {
      theme: 'dark',
    },
    dataLabels: {
      enabled: true,
      style: {
        colors: ['#FFF']
      }
    },
  };

  if (loading) {
    return <Loader />;
  }

  return (
    <>
      <DashCard title="Veículos - Revisão Periódica">
        <Row className="mt-4">
          <Col md="7">
            <div style={{ height: '240px' }}>
              <Chart options={options} series={series} type="bar" height="250" />
            </div>
          </Col>
          <Col md="5">
            <h2 className="mb-1 mt-3 fs-1">{Number(porcentagemAtivos).toFixed(2)} %</h2>
            <span className="text-muted">{totalCount} Veículos ativos</span>
            <div className="vstack gap-3 mt-4 pt-1 justify-content-center">
              <div className="d-flex align-items-center">
                <i className="bi bi-circle-fill fs-6 me-2" style={{ color: '#007bff' }}></i>
                <Button color='white' onClick={() => openModal('Veículos Ativos', veiculos.filter(v => parseInt(v.kmsrestante, 10) > 1000))} className="uniform-button">Regular</Button>
              </div>
              <div className="d-flex align-items-center">
                <i className="bi bi-circle-fill fs-6 me-2 text-warning"></i>
                <Button color='white' onClick={() => openModal('Veículos A vencer', veiculos.filter(v => parseInt(v.kmsrestante, 10) > 0 && parseInt(v.kmsrestante, 10) <= 1000))} className="uniform-button">A Vencer</Button>
              </div>
              <div className="d-flex align-items-center">
                <i className="bi bi-circle-fill fs-6 me-2 text-danger"></i>
                <Button color='white' onClick={() => openModal('Veículos Irregulares', veiculos.filter(v => parseInt(v.kmsrestante, 10) <= 0))} className="uniform-button">Irregular</Button>
              </div>
            </div>
          </Col>
        </Row>
      </DashCard>

      {/* Modal de Veículos */}
      <InspecaoPeriodicaModal
        isOpen={modalOpen}
        toggle={() => setModalOpen(!modalOpen)}
        data={modalData}
        title={modalTitle}
        refreshData={refreshData}
        originalData={originalData}
      />
    </>
  );
};

export default VeiculosInspecaoPeriodica;