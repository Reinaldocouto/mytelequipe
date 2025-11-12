import React, { useState, useEffect } from 'react';
import { Row, Col } from 'reactstrap';
import IndicadorCard from '../dashboardCards/IndicadorCard';
import api from '../../../services/api';

const IndicadorAlerta = () => {
  const [alerts, setAlerts] = useState([]);

  useEffect(() => {
    const params = {
      busca: '',
      idcliente: localStorage.getItem('sessionCodidcliente'),
      idusuario: localStorage.getItem('sessionId'),
      idloja: localStorage.getItem('sessionloja'),
      deletado: 0,
    };

    const processAlerts = (data) => {
      const today = new Date();
      let mosCount = 0;
      let insCount = 0;

      data.forEach((item) => {
        const dataInicioEntrega = new Date(item.datainicioprevistasolicitantebaselinemosdia);
        const dataRecebimento = item.datarecebimentodositemosreportadodia;

        if (dataRecebimento === null && dataInicioEntrega < today) {
          mosCount += 1;
        }

        const dataFimInstalacaoPlanejada = new Date(item.datafiminstalacaoplanejadodia);
        const dataConclusaoReportada = item.dataconclusaoreportadodia;
        const dataValidacaoInstalacao = item.datavalidacaoinstalacaodia;

        if (dataConclusaoReportada === null && dataValidacaoInstalacao === null && dataFimInstalacaoPlanejada < today) {
          insCount += 1;
        }
      });

      const processedAlerts = [
        {
          id: 1,
          title: 'Planejamento Vencido',
          values: [
            { label: 'MOS', value: mosCount },
            { label: 'INS', value: insCount },
          ],
        },
        {
          id: 2,
          title: 'SLA Instalação',
          values: [
            { label: 'Obras atrasadas', value: 45 },
            { label: 'Meta Ins. Faltantes', value: 30 },
          ],
        },
        {
          id: 3,
          title: 'ASP on Site',
          values: [
            { label: 'Não Localizados', value: 20 },
            { label: 'Localizados', value: 50 },
            { label: 'Sem AR', value: 10 },
          ],
        },
        {
          id: 4,
          title: 'Progresso de Obra',
          values: [
            { label: 'Obra 48H', value: 15 },
            { label: 'MOS Prog.', value: 25 },
            { label: 'RSA 48hrs', value: 5 },
          ],
        },
        {
          id: 5,
          title: 'Obras Paralizadas',
          values: [
            { label: 'Paralizações ASP', value: 12 },
            { label: 'Paralizações EHS', value: 8 },
          ],
        },
        {
          id: 6,
          title: 'Tickets em Aberto',
          values: [
            { label: 'Em aberto', value: 22 },
          ],
        },
        {
          id: 7,
          title: 'Integração',
          values: [
            { label: 'Sem Valid. Eribox', value: 5 },
          ],
        },
      ];

      setAlerts(processedAlerts);
    };

    const fetchData = async () => {
      try {
        const { data } = await api.get('v1/projetoericsson', { params });
        processAlerts(data);
      } catch (err) {
        console.error(err.message);
      }
    };

    fetchData();
  }, []);

  return (
    <Row>
      {alerts.map((alert) => (
        <Col lg="4" key={alert.id}>
          <IndicadorCard data={alert} />
        </Col>
      ))}
    </Row>
  );
};

export default IndicadorAlerta;