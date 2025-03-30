package ModeloDAO;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import Modelo.Transacao;
import ModeloJDBC.ConnectionFactory;

public class TransacaoDAO {

    public void inserir(Transacao transacao) {
        Connection conexao = ConnectionFactory.getConnection();
        String sql = "INSERT INTO transacoes (data, categoria_id, tipo_pagamento, informacao_adicional, valor, tipo, usuario_id) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try {
            PreparedStatement pstmt = conexao.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setDate(1, Date.valueOf(transacao.getData()));
            pstmt.setInt(2, transacao.getCategoriaId());
            pstmt.setString(3, transacao.getTipoPagamento());
            pstmt.setString(4, transacao.getInformacaoAdicional());
            pstmt.setBigDecimal(5, transacao.getValor());
            pstmt.setString(6, transacao.getTipo().name().toLowerCase());
            pstmt.setInt(7, transacao.getUsuarioId());
            pstmt.executeUpdate();

            ResultSet rs = pstmt.getGeneratedKeys();
            if (rs.next()) {
                transacao.setIdTransacao(rs.getInt(1));
            }

            pstmt.close();
            conexao.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void alterar(Transacao transacao) {
        Connection conexao = ConnectionFactory.getConnection();
        String sql = "UPDATE transacoes SET data = ?, categoria_id = ?, tipo_pagamento = ?, "
                   + "informacao_adicional = ?, valor = ?, tipo = ?, usuario_id = ? WHERE idTransacao = ?";
        
        try {
            PreparedStatement pstmt = conexao.prepareStatement(sql);
            pstmt.setDate(1, Date.valueOf(transacao.getData()));
            pstmt.setInt(2, transacao.getCategoriaId());
            pstmt.setString(3, transacao.getTipoPagamento());
            pstmt.setString(4, transacao.getInformacaoAdicional());
            pstmt.setBigDecimal(5, transacao.getValor());
            pstmt.setString(6, transacao.getTipo().name().toLowerCase());
            pstmt.setInt(7, transacao.getUsuarioId());
            pstmt.setInt(8, transacao.getIdTransacao());
            pstmt.executeUpdate();

            pstmt.close();
            conexao.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void excluir(int idTransacao) {
        Connection conexao = ConnectionFactory.getConnection();
        String sql = "DELETE FROM transacoes WHERE idTransacao = ?";
        
        try {
            PreparedStatement pstmt = conexao.prepareStatement(sql);
            pstmt.setInt(1, idTransacao);
            pstmt.executeUpdate();

            pstmt.close();
            conexao.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public Transacao pesquisarPorCodigo(int idTransacao) {
        Transacao transacao = null;
        Connection conexao = ConnectionFactory.getConnection();
        String sql = "SELECT idTransacao, data, categoria_id, tipo_pagamento, informacao_adicional, valor, tipo, usuario_id "
                   + "FROM transacoes WHERE idTransacao = ?";
        
        try {
            PreparedStatement pstmt = conexao.prepareStatement(sql);
            pstmt.setInt(1, idTransacao);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                transacao = new Transacao();
                transacao.setIdTransacao(rs.getInt("idTransacao"));
                transacao.setData(rs.getDate("data").toLocalDate());
                transacao.setCategoriaId(rs.getInt("categoria_id"));
                transacao.setTipoPagamento(rs.getString("tipo_pagamento"));
                transacao.setInformacaoAdicional(rs.getString("informacao_adicional"));
                transacao.setValor(rs.getBigDecimal("valor"));
                transacao.setTipo(Transacao.TipoTransacao.valueOf(rs.getString("tipo").toUpperCase()));
                transacao.setUsuarioId(rs.getInt("usuario_id"));
            }

            rs.close();
            pstmt.close();
            conexao.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return transacao;
    }

    public ArrayList<Transacao> pesquisarTodos() {
        ArrayList<Transacao> transacoes = new ArrayList<>();
        Connection conexao = ConnectionFactory.getConnection();
        String sql = "SELECT idTransacao, data, categoria_id, tipo_pagamento, informacao_adicional, valor, tipo, usuario_id FROM Transacoes";
        
        try {
            PreparedStatement pstmt = conexao.prepareStatement(sql);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Transacao transacao = new Transacao();
                transacao.setIdTransacao(rs.getInt("idTransacao"));
                transacao.setData(rs.getDate("data").toLocalDate());
                transacao.setCategoriaId(rs.getInt("categoria_id"));
                transacao.setTipoPagamento(rs.getString("tipo_pagamento"));
                transacao.setInformacaoAdicional(rs.getString("informacao_adicional"));
                transacao.setValor(rs.getBigDecimal("valor"));
                transacao.setTipo(Transacao.TipoTransacao.valueOf(rs.getString("tipo").toUpperCase())); // Ajuste para uppercase
                transacao.setUsuarioId(rs.getInt("usuario_id"));
                transacoes.add(transacao);
            }

            rs.close();
            pstmt.close();
            conexao.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return transacoes;
    }
}