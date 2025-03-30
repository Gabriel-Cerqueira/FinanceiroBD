package ModeloDAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import Modelo.Categoria;
import ModeloJDBC.ConnectionFactory;

public class CategoriaDAO {

    public void inserir(Categoria categoria) {
        Connection conexao = ConnectionFactory.getConnection();
        String sql = "INSERT INTO categorias (nome, usuario_id) VALUES (?, ?)";
        
        try {
            PreparedStatement pstmt = conexao.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, categoria.getNome());
            pstmt.setInt(2, categoria.getUsuarioId());
            pstmt.executeUpdate();

            ResultSet rs = pstmt.getGeneratedKeys();
            if (rs.next()) {
                categoria.setIdCategoria(rs.getInt(1));
            }

            pstmt.close();
            conexao.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void alterar(Categoria categoria) {
        Connection conexao = ConnectionFactory.getConnection();
        String sql = "UPDATE categorias SET nome = ?, usuario_id = ? WHERE idCategoria = ?";
        
        try {
            PreparedStatement pstmt = conexao.prepareStatement(sql);
            pstmt.setString(1, categoria.getNome());
            pstmt.setInt(2, categoria.getUsuarioId());
            pstmt.setInt(3, categoria.getIdCategoria());
            pstmt.executeUpdate();

            pstmt.close();
            conexao.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void excluir(int idCategoria) {
        Connection conexao = ConnectionFactory.getConnection();
        String sql = "DELETE FROM categorias WHERE idCategoria = ?";
        
        try {
            PreparedStatement pstmt = conexao.prepareStatement(sql);
            pstmt.setInt(1, idCategoria);
            pstmt.executeUpdate();

            pstmt.close();
            conexao.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public Categoria pesquisarPorCodigo(int idCategoria) {
        Categoria categoria = null;
        Connection conexao = ConnectionFactory.getConnection();
        String sql = "SELECT idCategoria, nome, usuario_id FROM categorias WHERE idCategoria = ?";
        
        try {
            PreparedStatement pstmt = conexao.prepareStatement(sql);
            pstmt.setInt(1, idCategoria);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                categoria = new Categoria();
                categoria.setIdCategoria(rs.getInt("idCategoria"));
                categoria.setNome(rs.getString("nome"));
                categoria.setUsuarioId(rs.getInt("usuario_id"));
            }

            rs.close();
            pstmt.close();
            conexao.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categoria;
    }

    public ArrayList<Categoria> pesquisarTodos() {
        ArrayList<Categoria> categorias = new ArrayList<>();
        Connection conexao = ConnectionFactory.getConnection();
        String sql = "SELECT idCategoria, nome, usuario_id FROM categorias";
        
        try {
            PreparedStatement pstmt = conexao.prepareStatement(sql);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Categoria categoria = new Categoria();
                categoria.setIdCategoria(rs.getInt("idCategoria"));
                categoria.setNome(rs.getString("nome"));
                categoria.setUsuarioId(rs.getInt("usuario_id"));
                categorias.add(categoria);
            }

            rs.close();
            pstmt.close();
            conexao.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categorias;
    }
}