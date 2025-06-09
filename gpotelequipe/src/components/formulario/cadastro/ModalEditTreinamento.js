/* eslint-disable jsx-a11y/label-has-associated-control */
import React, { useState, useEffect } from 'react';
import { Modal, ModalHeader, ModalBody, ModalFooter, Button } from 'reactstrap';
import PropTypes from 'prop-types';
import InputMask from 'react-input-mask';
import api from '../../../services/api';
import Loader from '../../../layouts/loader/Loader';

const ModalEditTreinamento = ({ show, setShow, treinamentoId, treinamentoData, setTreinamentoData, atualizaTreinamentos }) => {
  const [loading, setLoading] = useState(false);
  const [mensagem, setMensagem] = useState('');
  const [mensagemSucesso, setMensagemSucesso] = useState('');
  const [mascaraDataEmissao, setMascaraDataEmissao] = useState('');
  const [mascaraDataVencimento, setMascaraDataVencimento] = useState('');

  // Função para converter uma data do formato 'yyyy-mm-dd' para 'dd/mm/yyyy'
  const formatDateToDDMMYYYY = (dateStr) => {
    if (!dateStr) return '';
    const [year, month, day] = dateStr.split('-');
    return `${day}/${month}/${year}`;
  };

  // Função para converter uma data do formato 'dd/mm/yyyy' para 'yyyy-mm-dd'
  const formatDateToYYYY = (dateStr) => {
    if (!dateStr) return '';
    const [day, month, year] = dateStr.split('/');
    return `${year}-${month}-${day}`;
  };

  useEffect(() => {
    if (show && treinamentoData) {
      // Formata as datas para exibição no modal (dd/mm/yyyy)
      const formattedDataEmissao = formatDateToDDMMYYYY(treinamentoData.dataemissao);
      const formattedDataVencimento = formatDateToDDMMYYYY(treinamentoData.datavencimento);

      // Atualiza as máscaras para exibição, mas mantém as datas originais no formato correto
      setMascaraDataEmissao(formattedDataEmissao);
      setMascaraDataVencimento(formattedDataVencimento);
    }
  }, [show]);

  const handleSave = () => {
    setLoading(true);
    setMensagem('');
    setMensagemSucesso('');

    const payload = {
      idgestreinamento: treinamentoId.id,
    };

    // Verificar se o status foi alterado
    if (treinamentoData.statustreinamento) {
      payload.statustreinamento = treinamentoData.statustreinamento;
    }

    // Verificar se as datas foram alteradas
    if (mascaraDataEmissao && mascaraDataEmissao.length === 10) {
      payload.dataemissao = formatDateToYYYY(mascaraDataEmissao);
    }

    if (mascaraDataVencimento && mascaraDataVencimento.length === 10) {
      payload.datavencimentotreinamento = formatDateToYYYY(mascaraDataVencimento);
    }

    console.log('Payload enviado:', payload);

    api.post('v1/pessoa/atualizatreinamento', payload)
      .then((response) => {
        if (response.status === 200) {
          //setMensagemSucesso('Treinamento atualizado com sucesso!');
          atualizaTreinamentos();
          setShow(false);
        } else {
          setMensagem('Erro ao atualizar o treinamento');
        }
        setLoading(false);
      })
      .catch((err) => {
        if (err.response && err.response.status === 500) {
          setMensagem('Data de emissão ou data de vencimento inválida.');
        } else {
          setMensagem(`Erro na requisição: ${err.message}`);
        }
        setLoading(false);
        console.log(err);
      });
  };

  return (
    <Modal isOpen={show} toggle={() => setShow(false)} backdrop="static" keyboard={false}>
      <ModalHeader toggle={() => setShow(false)}>Editar Treinamento</ModalHeader>
      <ModalBody>
        {mensagem && <div className="alert alert-danger">{mensagem}</div>}
        {mensagemSucesso && <div className="alert alert-success">{mensagemSucesso}</div>}
        {loading ? (
          <Loader />
        ) : (
          <div className="row">
            <div className="col-sm-6">
              Data Emissão
              <InputMask
                mask="99/99/9999"
                value={mascaraDataEmissao}
                onChange={(e) => {
                  const inputValue = e.target.value;
                  setMascaraDataEmissao(inputValue);

                  // Verifica se a data está completa
                  if (inputValue.length === 10) {
                    const [dia, mes, ano] = inputValue.split('/');
                    const dataFormatada = `${ano}-${mes}-${dia}`;
                    setTreinamentoData({
                      ...treinamentoData,
                      dataemissao: dataFormatada,
                    });
                  }
                }}
                maskChar={null}
                placeholder="dd/mm/aaaa"
              >
                {(inputProps) => <input {...inputProps} type="text" className="form-control" />}
              </InputMask>
            </div>
            <div className="col-sm-6">
              Data Validade
              <InputMask
                mask="99/99/9999"
                value={mascaraDataVencimento}
                onChange={(e) => {
                  const inputValue = e.target.value;
                  setMascaraDataVencimento(inputValue);

                  // Verifica se a data está completa
                  if (inputValue.length === 10) {
                    const [dia, mes, ano] = inputValue.split('/');
                    const dataFormatada = `${ano}-${mes}-${dia}`;
                    setTreinamentoData({
                      ...treinamentoData,
                      datavencimento: dataFormatada,
                    });
                  }
                }}
                maskChar={null}
                placeholder="dd/mm/aaaa"
              >
                {(inputProps) => <input {...inputProps} type="text" className="form-control" />}
              </InputMask>
            </div>
            <div className="col-sm-12 mt-3">
              <label htmlFor="statustreinamento">Status</label>
              <select
                id="statustreinamento"
                className="form-control"
                value={treinamentoData.statustreinamento || ''}
                onChange={(e) => setTreinamentoData({ ...treinamentoData, statustreinamento: e.target.value })}
              >
                <option value="">Escolha uma opção</option>
                <option value="NAO SE APLICA">Não se aplica</option>
                <option value="PENDENTE">Pendente</option>
              </select>
            </div>
          </div>
        )}
      </ModalBody>
      <ModalFooter>
        <Button color="success" onClick={handleSave}>Salvar</Button>
        <Button color="secondary" onClick={() => setShow(false)}>Cancelar</Button>
      </ModalFooter>
    </Modal>
  );
};

ModalEditTreinamento.propTypes = {
  show: PropTypes.bool.isRequired,
  setShow: PropTypes.func.isRequired,
  treinamentoId: PropTypes.number.isRequired,
  treinamentoData: PropTypes.object.isRequired,
  setTreinamentoData: PropTypes.func.isRequired,
  atualizaTreinamentos: PropTypes.func.isRequired,
};

export default ModalEditTreinamento;