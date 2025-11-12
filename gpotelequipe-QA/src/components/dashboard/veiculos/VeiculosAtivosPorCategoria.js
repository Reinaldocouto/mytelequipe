import React, { useState, useEffect } from 'react';
import Chart from 'react-apexcharts';
import { Button, Col, Row } from 'reactstrap';
import DashCard from '../dashboardCards/DashCard';
import api from '../../../services/api';
import Loader from '../../../layouts/loader/Loader';
import VeiculoModal from './VeiculoModal';

const VeiculosAtivosPorCategoria = () => {
  const [veiculos, setVeiculos] = useState([]);
  const [loading, setLoading] = useState(true);
  const [totalCount, setTotalCount] = useState(0);
  const [porcentagemAtivos, setPorcentagemAtivos] = useState(0);

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
      console.log('grafico dos veiculos ativos por categoria: ', response.data);
      const veiculosComCategoria = response.data.filter(v => v.categoria);

      setVeiculos(veiculosComCategoria);

      const ativos = veiculosComCategoria.filter(v => v.status && v.status.toLowerCase() === 'ativo').length;
      const totalComCategoria = veiculosComCategoria.length;

      setTotalCount(totalComCategoria);
      setPorcentagemAtivos(totalComCategoria > 0 ? (ativos / totalComCategoria) * 100 : 0);
    } catch (err) {
      console.error('Erro ao buscar veículos: ', err.message);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    listaveiculos();
  }, []);

  const getStatusCount = (categoria, status) => {
    return veiculos.filter(v => v.categoria && v.categoria.toLowerCase() === categoria && v.status && v.status.toLowerCase() === status).length;
  };

  const getNotInformedCount = (categoria) => {
    return veiculos.filter(v => v.categoria && v.categoria.toLowerCase() === categoria && (!v.status || (v.status.toLowerCase() !== 'ativo' && v.status.toLowerCase() !== 'inativo'))).length;
  };

  const openModal = (title, data) => {
    setModalTitle(title);
    setModalData(data);
    setModalOpen(true);
  };

  const series = [
    {
      name: 'Ativos',
      data: [
        getStatusCount('proprio', 'ativo'),
        getStatusCount('prestador', 'ativo'),
        getStatusCount('unidas', 'ativo'),
        getStatusCount('movida', 'ativo'),
        getStatusCount('localiza', 'ativo'),
        getStatusCount('outros', 'ativo')
      ],
      color: '#007bff',
    },
    {
      name: 'Inativos',
      data: [
        getStatusCount('proprio', 'inativo'),
        getStatusCount('prestador', 'inativo'),
        getStatusCount('unidas', 'inativo'),
        getStatusCount('movida', 'inativo'),
        getStatusCount('localiza', 'inativo'),
        getStatusCount('outros', 'inativo')
      ],
      color: '#FF0000',
    },
    {
      name: 'Não Informado',
      data: [
        getNotInformedCount('proprio'),
        getNotInformedCount('prestador'),
        getNotInformedCount('unidas'),
        getNotInformedCount('movida'),
        getNotInformedCount('localiza'),
        getNotInformedCount('outros')
      ],
      color: '#808080',
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
      <DashCard title="Veículos - Ativo por Categoria">
        <Row className="mt-4">
          <Col md="7">
            <div style={{ height: '240px' }}>
              <Chart options={options} series={series} type="bar" height="250" />
            </div>
          </Col>
          <Col md="5">
            <h2 className="mb-1 mt-3 fs-1">{Number(porcentagemAtivos).toFixed(2)} %</h2>
            <span className="text-muted">{totalCount} Veículos com categoria</span>
            <div className="vstack gap-3 mt-4 pt-1 justify-content-center">
              <div className="d-flex align-items-center">
              <i className="bi bi-circle-fill fs-6 me-2" style={{ color: '#007bff' }}></i>
                <Button color='white' onClick={() => openModal('Veículos Ativos', veiculos.filter(v => v.status && v.status.toLowerCase() === 'ativo'))} className="uniform-button">Ativos</Button>
              </div>
              <div className="d-flex align-items-center">
                <i className="bi bi-circle-fill fs-6 me-2 text-danger"></i>
                <Button color='white' onClick={() => openModal('Veículos Inativos', veiculos.filter(v => v.status && v.status.toLowerCase() === 'inativo'))} className="uniform-button">Inativos</Button>
              </div>
              <div className="d-flex align-items-center">
                <i className="bi bi-circle-fill fs-6 me-2 text-secondary"></i>
                <Button color='white' onClick={() => openModal('Veículos Não Informados', veiculos.filter(v => !v.status || (v.status.toLowerCase() !== 'ativo' && v.status.toLowerCase() !== 'inativo')))} className="uniform-button">Ñ Inform</Button>
              </div>
            </div>
          </Col>
        </Row>
      </DashCard>

      {/* Modal de Veículos */}
      <VeiculoModal
        isOpen={modalOpen}
        toggle={() => setModalOpen(!modalOpen)}
        data={modalData}
        title={modalTitle}
      />
    </>
  );
};

export default VeiculosAtivosPorCategoria;