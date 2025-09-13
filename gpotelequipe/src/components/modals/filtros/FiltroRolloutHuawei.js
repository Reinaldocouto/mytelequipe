import {
  Button,
  Modal,
  ModalBody,
  ModalHeader,
  ModalFooter,
  Form,
  FormGroup,
  Label,
  Input,
} from 'reactstrap';
import PropTypes from 'prop-types';
import { useEffect, useState } from 'react';
import SettingsIcon from '@mui/icons-material/Settings';
import FilterAltIcon from '@mui/icons-material/FilterAlt';
import ConfiguracaoCamposVisiveis from '../ConfiguracaoCamposVisiveis';

const FiltroRolloutHuawei = ({
  show1,
  toggle1,
  formValues,
  setFormValues,
  limparFiltro,
  aplicarFiltro,
  pessoas,
  empresas,
}) => {
  const [save, setSave] = useState(false);
  const [configModalOpen, setConfigModalOpen] = useState(false);
  const toggleConfigModal = () => setConfigModalOpen(!configModalOpen);
  console.log(show1);
  const applyFilter = () => {
    aplicarFiltro();
    setSave(true);
  };

  useEffect(() => {
    if (save) {
      toggle1();
    }
  }, [save]);

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setFormValues({ ...formValues, [name]: value });
  };

  const [fieldVisibility, setFieldVisibility] = useState({
    id: false,
    name: true,
    projeto: true,
    endSite: true,
    du: true,
    statusGeral: true,
    liderResponsavel: true,
    empresa: true,
    ativoNoPeriodo: true,
    fechamento: true,
    anoSemanaFechamento: true,
    confirmacaoPagamento: true,
    descricaoAdd: true,
    numeroVo: true,
    infra: true,
    town: true,
    latitude: true,
    longitude: true,
    reg: true,
    ddd: true,
    envioDaDemanda: true,
    mosPlanned: true,
    mosReal: true,
    semanaMos: true,
    mosStatus: true,
    integrationPlanned: true,
    testeTx: true,
    integrationReal: true,
    semanaIntegration: true,
    statusIntegracao: true,
    iti: true,
    qcPlanned: true,
    qcReal: true,
    semanaQc: true,
    qcStatus: true,
    observacao: true,
    logisticaReversaStatus: true,
    detentora: true,
    idDententora: true,
    formaDeAcesso: true,
    faturamento: true,
    faturamentoStatus: true,
    idOriginal: true,
    changeHistory: true,
    repOffice: true,
    projectCode: true,
    siteCode: true,
    siteName: true,
    siteId: true,
    subContractNo: true,
    prNo: true,
    poNo: true,
    poLineNo: true,
    shipmentNo: true,
    itemCode: true,
    itemDescription: true,
    itemDescriptionLocal: true,
    unitPrice: true,
    requestedQty: true,
    valorTelequipe: true,
    valorEquipe: true,
    billedQuantity: true,
    quantityCancel: true,
    dueQty: true,
    noteToReceiver: true,
    fobLookupCode: true,
    acceptanceDate: true,
    prPoAutomationSolutionOnlyChina: true,
    pessoa: true,
    ultimaAtualizacao: true,
  });

  return (
    <Modal
      isOpen
      toggle={toggle1}
      className="modal-dialog modal-lg modal-dialog-scrollable"
      backdrop="static"
      keyboard={false}
      size="lg"
    >
      <ModalHeader toggle={toggle1} className="border-bottom">
        <span className="fw-bold">Filtro de Pesquisa</span>
      </ModalHeader>
      <ModalBody className="px-4 py-3">
        <Form>
          {/* Campos text */}
          {fieldVisibility.id && (
            <FormGroup>
              <Label for="id" className="fw-bold">
                ID
              </Label>
              <Input
                type="text"
                id="id"
                name="id"
                value={formValues.id || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}
          {fieldVisibility.name && (
            <FormGroup>
              <Label for="name" className="fw-bold">
                Name
              </Label>
              <Input
                type="text"
                id="name"
                name="name"
                value={formValues.name || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}
          {fieldVisibility.projeto && (
            <FormGroup>
              <Label for="projeto" className="fw-bold">
                Projeto
              </Label>
              <Input
                type="select"
                id="projeto"
                name="projeto"
                value={formValues.projeto || ''}
                onChange={handleInputChange}
              >
                <option value="">SELECIONE</option>
                <option value="Tim WL SP">Tim WL SP</option>
                <option value="Tim WL Adicional">Tim WL Adicional</option>
              </Input>
            </FormGroup>
          )}
          {fieldVisibility.endSite && (
            <FormGroup>
              <Label for="endSite" className="fw-bold">
                Endereço do Site
              </Label>
              <Input
                type="text"
                id="endSite"
                name="endSite"
                value={formValues.endSite || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}
          {fieldVisibility.du && (
            <FormGroup>
              <Label for="du" className="fw-bold">
                DU
              </Label>
              <Input
                type="text"
                id="du"
                name="du"
                value={formValues.du || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}
          {fieldVisibility.statusGeral && (
            <FormGroup>
              <Label for="statusGeral" className="fw-bold">
                Status Geral
              </Label>
              <Input
                type="select"
                id="statusGeral"
                name="statusGeral"
                value={formValues.statusGeral || ''}
                onChange={handleInputChange}
              >
                <option value="">SELECIONE</option>
                <option value="QC Andamento">QC Andamento</option>
                <option value="Instalação em andamento">Instalação em andamento</option>
                <option value="DU via exceptuon">DU via exceptuon</option>
                <option value="Finalizado">Finalizado</option>
                <option value="Cancelado">Cancelado</option>
                <option value="Instalação paralisada">Instalação paralisada</option>
                <option value="Zeladoria">Zeladoria</option>
                <option value="QC Paralizado">QC Paralizado</option>
                <option value="Acesso bloqueado">Acesso bloqueado</option>
                <option value="Instalação paralizada">Instalação paralizada</option>
                <option value="Material devolvido">Material devolvido</option>
                <option value="Programar MOS">Programar MOS</option>
                <option value="Aguardando MOS">Aguardando MOS</option>
                <option value="Planejado">Planejado</option>
                <option value="QC pendente Huawei">QC pendente Huawei</option>
                <option value="QC Paralisado">QC Paralisado</option>
              </Input>
            </FormGroup>
          )}
          {fieldVisibility.liderResponsavel && (
            <FormGroup>
              <Label for="liderResponsavel" className="fw-bold">
                Líder Responsável
              </Label>
              <Input
                type="select"
                id="liderResponsavel"
                name="liderResponsavel"
                value={formValues.liderResponsavel || ''}
                onChange={handleInputChange}
              >
                <option value="">SELECIONE</option>
                {pessoas &&
                  Object.keys(pessoas).map((key) => (
                    <option key={key} value={pessoas[key]}>
                      {pessoas[key]}
                    </option>
                  ))}
              </Input>
            </FormGroup>
          )}
          {fieldVisibility.empresa && (
            <FormGroup>
              <Label for="empresa" className="fw-bold">
                Empresa
              </Label>
              <Input
                type="select"
                id="empresa"
                name="empresa"
                value={formValues.empresa || ''}
                onChange={handleInputChange}
              >
                <option value="">SELECIONE</option>
                {empresas &&
                  Object.keys(empresas).map((key) => (
                    <option key={key} value={empresas[key]}>
                      {empresas[key]}
                    </option>
                  ))}
              </Input>
            </FormGroup>
          )}
          {fieldVisibility.ativoNoPeriodo && (
            <FormGroup>
              <Label for="ativoNoPeriodo" className="fw-bold">
                Ativo no Período
              </Label>
              <Input
                type="select"
                id="ativoNoPeriodo"
                name="ativoNoPeriodo"
                value={formValues.ativoNoPeriodo || ''}
                onChange={handleInputChange}
              >
                <option value="">SELECIONE</option>
                <option value="Aguardando">Aguardando</option>
                <option value="Ativo">Ativo</option>
                <option value="Inativo">Inativo</option>
                <option value="Cancelado">Cancelado</option>
              </Input>
            </FormGroup>
          )}
          {fieldVisibility.fechamento && (
            <FormGroup>
              <Label for="fechamento" className="fw-bold">
                Fechamento
              </Label>
              <Input
                type="select"
                id="fechamento"
                name="fechamento"
                value={formValues.fechamento || ''}
                onChange={handleInputChange}
              >
                <option value="">SELECIONE</option>
                <option value="TLQP">TLQP</option>
                <option value="Sim">Sim</option>
                <option value="Não">Não</option>
                <option value="Cancelado">Cancelado</option>
              </Input>
            </FormGroup>
          )}
          {fieldVisibility.anoSemanaFechamento && (
            <FormGroup>
              <Label for="anoSemanaFechamento" className="fw-bold">
                Ano/Semana Fechamento
              </Label>
              <Input
                type="text"
                id="anoSemanaFechamento"
                name="anoSemanaFechamento"
                value={formValues.anoSemanaFechamento || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}
          {fieldVisibility.descricaoAdd && (
            <FormGroup>
              <Label for="descricaoAdd" className="fw-bold">
                Descrição Adicional
              </Label>
              <Input
                type="text"
                id="descricaoAdd"
                name="descricaoAdd"
                value={formValues.descricaoAdd || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}
          {fieldVisibility.numeroVo && (
            <FormGroup>
              <Label for="numeroVo" className="fw-bold">
                Número VO
              </Label>
              <Input
                type="text"
                id="numeroVo"
                name="numeroVo"
                value={formValues.numeroVo || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}
          {fieldVisibility.infra && (
            <FormGroup>
              <Label for="infra" className="fw-bold">
                Infra
              </Label>
              <Input
                type="select"
                id="infra"
                name="infra"
                value={formValues.infra || ''}
                onChange={handleInputChange}
              >
                <option value="">SELECIONE</option>
                <option value="BioSite">BioSite</option>
                <option value="Caixa D'Água">Caixa d Água</option>
                <option value="Greenfield">Greenfield</option>
                <option value="Rooftop">Rooftop</option>
                <option value="Indoor">Indoor</option>
                <option value="Totem">Totem</option>
              </Input>
            </FormGroup>
          )}
          {fieldVisibility.town && (
            <FormGroup>
              <Label for="town" className="fw-bold">
                Cidade
              </Label>
              <Input
                type="text"
                id="town"
                name="town"
                value={formValues.town || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}
          {fieldVisibility.reg && (
            <FormGroup>
              <Label for="reg" className="fw-bold">
                Região
              </Label>
              <Input
                type="text"
                id="reg"
                name="reg"
                value={formValues.reg || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}
          {fieldVisibility.ddd && (
            <FormGroup>
              <Label for="ddd" className="fw-bold">
                DDD
              </Label>
              <Input
                type="text"
                id="ddd"
                name="ddd"
                value={formValues.ddd || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}
          {fieldVisibility.envioDaDemanda && (
            <FormGroup>
              <Label for="envioDaDemanda" className="fw-bold">
                Envio da Demanda
              </Label>
              <Input
                type="date"
                id="envioDaDemanda"
                name="envioDaDemanda"
                value={formValues.envioDaDemanda || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}
          {fieldVisibility.mosPlanned && (
            <FormGroup>
              <Label for="mosPlanned" className="fw-bold">
                MOS Planned
              </Label>
              <Input
                type="date"
                id="mosPlanned"
                name="mosPlanned"
                value={formValues.mosPlanned || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}
          {fieldVisibility.mosReal && (
            <FormGroup>
              <Label for="mosReal" className="fw-bold">
                MOS Real
              </Label>
              <Input
                type="date"
                id="mosReal"
                name="mosReal"
                value={formValues.mosReal || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}
          {fieldVisibility.mosStatus && (
            <FormGroup>
              <Label for="mosStatus" className="fw-bold">
                MOS Status
              </Label>
              <Input
                type="select"
                id="mosStatus"
                name="mosStatus"
                value={formValues.mosStatus || ''}
                onChange={handleInputChange}
              >
                <option value="">SELECIONE</option>
                <option value="Finalizado">Finalizado</option>
                <option value="Cancelado">Cancelado</option>
                <option value="Pendente">Pendente</option>
              </Input>
            </FormGroup>
          )}
          {fieldVisibility.integrationPlanned && (
            <FormGroup>
              <Label for="integrationPlanned" className="fw-bold">
                Integration Planned
              </Label>
              <Input
                type="date"
                id="integrationPlanned"
                name="integrationPlanned"
                value={formValues.integrationPlanned || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}
          {fieldVisibility.integrationReal && (
            <FormGroup>
              <Label for="integrationReal" className="fw-bold">
                Integration Real
              </Label>
              <Input
                type="date"
                id="integrationReal"
                name="integrationReal"
                value={formValues.integrationReal || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}
          {fieldVisibility.statusIntegracao && (
            <FormGroup>
              <Label for="statusIntegracao" className="fw-bold">
                Status Integração
              </Label>
              <Input
                type="select"
                id="statusIntegracao"
                name="statusIntegracao"
                value={formValues.statusIntegracao || ''}
                onChange={handleInputChange}
              >
                <option value="">SELECIONE</option>
                <option value="Finalizado">Finalizado</option>
                <option value="Pendente">Pendente</option>
                <option value="Cancelado">Cancelado</option>
                <option value="Sem TX">Sem TX</option>
              </Input>
            </FormGroup>
          )}
          {fieldVisibility.testeTx && (
            <FormGroup>
              <Label for="testeTx" className="fw-bold">
                Teste TX
              </Label>
              <Input
                type="select"
                id="testeTx"
                name="testeTx"
                value={formValues.testeTx || ''}
                onChange={handleInputChange}
              >
                <option value="">SELECIONE</option>
                <option value="NOK">NOK</option>
                <option value="OK">OK</option>
                <option value="CA">CA</option>
                <option value="S/TX">S/TX</option>
              </Input>
            </FormGroup>
          )}
          {/* Continua manualmente para todos os campos restantes */}
          {fieldVisibility.iti && (
            <FormGroup>
              <Label for="iti" className="fw-bold">
                ITI
              </Label>
              <Input
                type="text"
                id="iti"
                name="iti"
                value={formValues.iti || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}
          {fieldVisibility.qcPlanned && (
            <FormGroup>
              <Label for="qcPlanned" className="fw-bold">
                QC Planned
              </Label>
              <Input
                type="date"
                id="qcPlanned"
                name="qcPlanned"
                value={formValues.qcPlanned || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}
          {fieldVisibility.qcReal && (
            <FormGroup>
              <Label for="qcReal" className="fw-bold">
                QC Real
              </Label>
              <Input
                type="date"
                id="qcReal"
                name="qcReal"
                value={formValues.qcReal || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}
          {fieldVisibility.semanaQc && (
            <FormGroup>
              <Label for="semanaQc" className="fw-bold">
                Semana QC
              </Label>
              <Input
                type="text"
                id="semanaQc"
                name="semanaQc"
                value={formValues.semanaQc || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}
          {fieldVisibility.qcStatus && (
            <FormGroup>
              <Label for="qcStatus" className="fw-bold">
                QC Status
              </Label>
              <Input
                type="select"
                id="qcStatus"
                name="qcStatus"
                value={formValues.qcStatus || ''}
                onChange={handleInputChange}
              >
                <option value="">SELECIONE</option>
                <option value="Pendente">Pendente</option>
                <option value="QC vinculado">QC vinculado</option>
                <option value="Finalizado">Finalizado</option>
                <option value="Cancelado">Cancelado</option>
                <option value="Pendente Huawei">Pendente Huawei</option>
              </Input>
            </FormGroup>
          )}
          {fieldVisibility.observacao && (
            <FormGroup>
              <Label for="observacao" className="fw-bold">
                Observação
              </Label>
              <Input
                type="text"
                id="observacao"
                name="observacao"
                value={formValues.observacao || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}
          {fieldVisibility.logisticaReversaStatus && (
            <FormGroup>
              <Label for="logisticaReversaStatus" className="fw-bold">
                Logística Reversa Status
              </Label>
              <Input
                type="select"
                id="logisticaReversaStatus"
                name="logisticaReversaStatus"
                value={formValues.logisticaReversaStatus || ''}
                onChange={handleInputChange}
              >
                <option value="">SELECIONE</option>
                <option value="Vandalizado">Vandalizado</option>
                <option value="Pendente">Pendente</option>
                <option value="Respon. Huawei">Respon. Huawei</option>
                <option value="Cancelado">Cancelado</option>
                <option value="Finalizado">Finalizado</option>
                <option value="Site novo">Site novo</option>
                <option value="S/ Coleta">S/ Coleta</option>
              </Input>
            </FormGroup>
          )}
          {fieldVisibility.detentora && (
            <FormGroup>
              <Label for="detentora" className="fw-bold">
                Detentora
              </Label>
              <Input
                type="text"
                id="detentora"
                name="detentora"
                value={formValues.detentora || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}
          {fieldVisibility.idDententora && (
            <FormGroup>
              <Label for="idDententora" className="fw-bold">
                ID Detentora
              </Label>
              <Input
                type="text"
                id="idDententora"
                name="idDententora"
                value={formValues.idDententora || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}
          {fieldVisibility.formaDeAcesso && (
            <FormGroup>
              <Label for="formaDeAcesso" className="fw-bold">
                Forma de Acesso
              </Label>
              <Input
                type="text"
                id="formaDeAcesso"
                name="formaDeAcesso"
                value={formValues.formaDeAcesso || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}
          {fieldVisibility.faturamento && (
            <FormGroup>
              <Label for="faturamento" className="fw-bold">
                Faturamento
              </Label>
              <Input
                type="number"
                step="0.01"
                id="faturamento"
                name="faturamento"
                value={formValues.faturamento || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}
          {fieldVisibility.faturamentoStatus && (
            <FormGroup>
              <Label for="faturamentoStatus" className="fw-bold">
                Faturamento Status
              </Label>
              <Input
                type="select"
                id="faturamentoStatus"
                name="faturamentoStatus"
                value={formValues.faturamentoStatus || ''}
                onChange={handleInputChange}
              >
                <option value="">SELECIONE</option>
                <option value="Pendente">Pendente</option>
                <option value="Pago">Pago</option>
                <option value="Cancelado">Cancelado</option>
                <option value="Retido">Retido</option>
              </Input>
            </FormGroup>
          )}
          {fieldVisibility.idOriginal && (
            <FormGroup>
              <Label for="idOriginal" className="fw-bold">
                ID Original
              </Label>
              <Input
                type="text"
                id="idOriginal"
                name="idOriginal"
                value={formValues.idOriginal || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}
          {fieldVisibility.changeHistory && (
            <FormGroup>
              <Label for="changeHistory" className="fw-bold">
                Change History
              </Label>
              <Input
                type="text"
                id="changeHistory"
                name="changeHistory"
                value={formValues.changeHistory || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}
          {fieldVisibility.repOffice && (
            <FormGroup>
              <Label for="repOffice" className="fw-bold">
                Rep Office
              </Label>
              <Input
                type="text"
                id="repOffice"
                name="repOffice"
                value={formValues.repOffice || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}
          {fieldVisibility.projectCode && (
            <FormGroup>
              <Label for="projectCode" className="fw-bold">
                Project Code
              </Label>
              <Input
                type="text"
                id="projectCode"
                name="projectCode"
                value={formValues.projectCode || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}
          {fieldVisibility.siteCode && (
            <FormGroup>
              <Label for="siteCode" className="fw-bold">
                Site Code
              </Label>
              <Input
                type="text"
                id="siteCode"
                name="siteCode"
                value={formValues.siteCode || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}
          {fieldVisibility.siteName && (
            <FormGroup>
              <Label for="siteName" className="fw-bold">
                Site Name
              </Label>
              <Input
                type="text"
                id="siteName"
                name="siteName"
                value={formValues.siteName || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}
          {fieldVisibility.siteId && (
            <FormGroup>
              <Label for="siteId" className="fw-bold">
                Site ID
              </Label>
              <Input
                type="text"
                id="siteId"
                name="siteId"
                value={formValues.siteId || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}
          {fieldVisibility.subContractNo && (
            <FormGroup>
              <Label for="subContractNo" className="fw-bold">
                Sub Contract No
              </Label>
              <Input
                type="text"
                id="subContractNo"
                name="subContractNo"
                value={formValues.subContractNo || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}
          {fieldVisibility.prNo && (
            <FormGroup>
              <Label for="prNo" className="fw-bold">
                PR No
              </Label>
              <Input
                type="text"
                id="prNo"
                name="prNo"
                value={formValues.prNo || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}
          {fieldVisibility.poNo && (
            <FormGroup>
              <Label for="poNo" className="fw-bold">
                PO No
              </Label>
              <Input
                type="text"
                id="poNo"
                name="poNo"
                value={formValues.poNo || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}
          {fieldVisibility.poLineNo && (
            <FormGroup>
              <Label for="poLineNo" className="fw-bold">
                PO Line No
              </Label>
              <Input
                type="text"
                id="poLineNo"
                name="poLineNo"
                value={formValues.poLineNo || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}
          {fieldVisibility.shipmentNo && (
            <FormGroup>
              <Label for="shipmentNo" className="fw-bold">
                Shipment No
              </Label>
              <Input
                type="text"
                id="shipmentNo"
                name="shipmentNo"
                value={formValues.shipmentNo || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}
          {fieldVisibility.itemCode && (
            <FormGroup>
              <Label for="itemCode" className="fw-bold">
                Item Code
              </Label>
              <Input
                type="text"
                id="itemCode"
                name="itemCode"
                value={formValues.itemCode || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}
          {fieldVisibility.itemDescription && (
            <FormGroup>
              <Label for="itemDescription" className="fw-bold">
                Item Description
              </Label>
              <Input
                type="text"
                id="itemDescription"
                name="itemDescription"
                value={formValues.itemDescription || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}
          {fieldVisibility.itemDescriptionLocal && (
            <FormGroup>
              <Label for="itemDescriptionLocal" className="fw-bold">
                Item Description Local
              </Label>
              <Input
                type="text"
                id="itemDescriptionLocal"
                name="itemDescriptionLocal"
                value={formValues.itemDescriptionLocal || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}
          {fieldVisibility.unitPrice && (
            <FormGroup>
              <Label for="unitPrice" className="fw-bold">
                Unit Price
              </Label>
              <Input
                type="number"
                step="0.01"
                id="unitPrice"
                name="unitPrice"
                value={formValues.unitPrice || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}
          {fieldVisibility.requestedQty && (
            <FormGroup>
              <Label for="requestedQty" className="fw-bold">
                Requested Qty
              </Label>
              <Input
                type="number"
                id="requestedQty"
                name="requestedQty"
                value={formValues.requestedQty || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}
          {fieldVisibility.valorTelequipe && (
            <FormGroup>
              <Label for="valorTelequipe" className="fw-bold">
                Valor Telequipe
              </Label>
              <Input
                type="number"
                step="0.01"
                id="valorTelequipe"
                name="valorTelequipe"
                value={formValues.valorTelequipe || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}
          {fieldVisibility.valorEquipe && (
            <FormGroup>
              <Label for="valorEquipe" className="fw-bold">
                Valor Equipe
              </Label>
              <Input
                type="number"
                step="0.01"
                id="valorEquipe"
                name="valorEquipe"
                value={formValues.valorEquipe || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}
          {fieldVisibility.billedQuantity && (
            <FormGroup>
              <Label for="billedQuantity" className="fw-bold">
                Billed Quantity
              </Label>
              <Input
                type="number"
                id="billedQuantity"
                name="billedQuantity"
                value={formValues.billedQuantity || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}
          {fieldVisibility.quantityCancel && (
            <FormGroup>
              <Label for="quantityCancel" className="fw-bold">
                Quantity Cancel
              </Label>
              <Input
                type="number"
                id="quantityCancel"
                name="quantityCancel"
                value={formValues.quantityCancel || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}
          {fieldVisibility.dueQty && (
            <FormGroup>
              <Label for="dueQty" className="fw-bold">
                Due Qty
              </Label>
              <Input
                type="number"
                id="dueQty"
                name="dueQty"
                value={formValues.dueQty || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}
          {fieldVisibility.noteToReceiver && (
            <FormGroup>
              <Label for="noteToReceiver" className="fw-bold">
                Note to Receiver
              </Label>
              <Input
                type="text"
                id="noteToReceiver"
                name="noteToReceiver"
                value={formValues.noteToReceiver || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}
          {fieldVisibility.fobLookupCode && (
            <FormGroup>
              <Label for="fobLookupCode" className="fw-bold">
                FOB Lookup Code
              </Label>
              <Input
                type="text"
                id="fobLookupCode"
                name="fobLookupCode"
                value={formValues.fobLookupCode || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}
          {fieldVisibility.acceptanceDate && (
            <FormGroup>
              <Label for="acceptanceDate" className="fw-bold">
                Acceptance Date
              </Label>
              <Input
                type="date"
                id="acceptanceDate"
                name="acceptanceDate"
                value={formValues.acceptanceDate || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}
          {fieldVisibility.prPoAutomationSolutionOnlyChina && (
            <FormGroup>
              <Label for="prPoAutomationSolutionOnlyChina" className="fw-bold">
                PR/PO Automation Solution Only China
              </Label>
              <Input
                type="text"
                id="prPoAutomationSolutionOnlyChina"
                name="prPoAutomationSolutionOnlyChina"
                value={formValues.prPoAutomationSolutionOnlyChina || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}
          {fieldVisibility.pessoa && (
            <FormGroup>
              <Label for="pessoa" className="fw-bold">
                Pessoa
              </Label>
              <Input
                type="text"
                id="pessoa"
                name="pessoa"
                value={formValues.pessoa || ''}
                onChange={handleInputChange}
              />
            </FormGroup>
          )}
          {fieldVisibility.ultimaAtualizacao && (
            <FormGroup>
              <Label for="ultimaAtualizacao" className="fw-bold">
                Última Atualização
              </Label>
              <Input
                type="datetime-local"
                id="ultimaAtualizacao"
                name="ultimaAtualizacao"
                value={
                  formValues.ultimaAtualizacao ? formValues.ultimaAtualizacao.replace('Z', '') : ''
                }
                onChange={handleInputChange}
              />
            </FormGroup>
          )}
        </Form>

        <ConfiguracaoCamposVisiveis
          isOpen={configModalOpen}
          toggle={toggleConfigModal}
          fieldVisibility={fieldVisibility}
          setFieldVisibility={setFieldVisibility}
          LOCAL_STORAGE_KEY="rollouthuawei"
        />
      </ModalBody>
      <ModalFooter className="d-flex justify-content-between">
        <Button
          color="none"
          className="d-flex align-items-center"
          onClick={toggleConfigModal}
          size="sm"
        >
          <SettingsIcon fontSize="small" className="me-1" /> Configurar Filtro
        </Button>
        <div className="d-flex justify-content-between gap-2">
          <Button color="secondary" onClick={toggle1} outline>
            Cancelar
          </Button>
          <Button color="primary" onClick={applyFilter}>
            <FilterAltIcon fontSize="small" className="me-1" /> Aplicar Filtro
          </Button>
          <Button color="secondary" onClick={limparFiltro}>
            <FilterAltIcon fontSize="small" className="me-1" /> Limpar Filtro
          </Button>
        </div>
      </ModalFooter>
    </Modal>
  );
};

FiltroRolloutHuawei.propTypes = {
  show1: PropTypes.bool.isRequired,
  toggle1: PropTypes.func.isRequired,
  formValues: PropTypes.object.isRequired,
  pessoas: PropTypes.object.isRequired,
  empresas: PropTypes.object.isRequired,
  setFormValues: PropTypes.func.isRequired,
  limparFiltro: PropTypes.func.isRequired,
  aplicarFiltro: PropTypes.func.isRequired,
};

export default FiltroRolloutHuawei;
