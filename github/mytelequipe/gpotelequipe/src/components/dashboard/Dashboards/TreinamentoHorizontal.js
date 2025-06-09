import React, { useEffect, useState, useCallback } from 'react';
import Chart from 'react-apexcharts';
import DashCard from '../dashboardCards/DashCard';
import api from '../../../services/api';

const TreinamentoHorizontal = () => {
  const [loading, setLoading] = useState(true);
  const [dataSeries, setDataSeries] = useState([]);
  const [categories, setCategories] = useState([]);

  const statusColors = {
    'Aprovado': '#007bff', // azul
    'Não se aplica': '#808080', // Cinza
    'Pendente': '#FFA500', // Laranja
    'Vencido': '#FF0000', // Vermelho
    'Renovar': '#FFFF00' // Amarelo
  };

  const statusMapping = {
    'NAO SE APLICA': 'Não se aplica',
    'PENDENTE': 'Pendente',
  };

  const fetchTreinamentos = useCallback(async () => {
    try {
      const response = await api.get('v1/pessoa/treinamentogeral');
      if (response.status === 200) {
        const { data } = response;
        //console.log("data dados do status do treinamento: ", data);
  
        const trainingsData = {};
        data.forEach((item) => {
          if (!trainingsData[item.descricao]) {
            trainingsData[item.descricao] = {
              'Aprovado': 0,
              'Não se aplica': 0,
              'Pendente': 0,
              'Vencido': 0,
              'Renovar': 0,
            };
          }
  
          const status = statusMapping[item.statustreinamento];
  
          if (item.dataemissao && item.datavencimento) {
            const dataEmissao = new Date(item.dataemissao.split('/').reverse().join('-'));
            const dataVencimento = new Date(item.datavencimento.split('/').reverse().join('-'));
            const hoje = new Date();
            const diasParaVencimento = (dataVencimento - hoje) / (1000 * 60 * 60 * 24);
  
            if (status === 'Pendente' || status === 'Não se aplica') {
              trainingsData[item.descricao][status] += 1;
            } else if (hoje > dataVencimento) {
              trainingsData[item.descricao].Vencido += 1;
            } else if (diasParaVencimento <= 30) {
              trainingsData[item.descricao].Renovar += 1;
            } else if (hoje >= dataEmissao && hoje <= dataVencimento) {
              trainingsData[item.descricao].Aprovado += 1;
            }
          }
        });
  
        const series = Object.keys(statusColors).map((status) => ({
          name: status,
          data: Object.keys(trainingsData).map((desc) => trainingsData[desc][status] || 0)
        }));
  
        setCategories(Object.keys(trainingsData));
        setDataSeries(series);
      }
      setLoading(false);
    } catch (err) {
      console.error('Erro ao buscar dados de treinamentos:', err);
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    fetchTreinamentos();
  }, [fetchTreinamentos]);

  const options = {
    chart: {
      type: 'bar',
      stacked: true,
      toolbar: {
        show: true
      },
    },
    colors: Object.values(statusColors),
    plotOptions: {
      bar: {
        horizontal: true,
      }
    },
    xaxis: {
      categories,
    },
    legend: {
      position: 'right',
      offsetY: 40
    },
    dataLabels: {
      enabled: true,
      formatter: (val) => `${val}`,
      style: {
        colors: ['#FFF']
      }
    },
    tooltip: {
      y: {
        formatter: (val) => `${val} pessoas`
      }
    },
    grid: {
      show: true,
      xaxis: {
        lines: {
          show: true // Linhas verticais
        }
      },
      yaxis: {
        lines: {
          show: false // Desativar linhas horizontais 
        }
      }
    }
  };

  return (
    <DashCard title="Treinamentos">
      {loading ? (
        <p>Carregando...</p>
      ) : (
        <div style={{ height: '500px' }}>
          <Chart options={options} series={dataSeries} type="bar" height="400" />
        </div>
      )}
    </DashCard>
  );
};

export default TreinamentoHorizontal;