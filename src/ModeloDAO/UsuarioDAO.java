package ModeloDAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import Modelo.Usuario;
import ModeloJDBC.ConnectionFactory;

public class UsuarioDAO {

    public void inserir(Usuario usuario) {
        Connection conexao = ConnectionFactory.getConnection();
        String sql = "INSERT INTO Usuarios (nome, email, senha) VALUES (?, ?, ?)";
        
        try {
            PreparedStatement pstmt = conexao.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, usuario.getNome());
            pstmt.setString(2, usuario.getEmail());
            pstmt.setString(3, usuario.getSenha());
            pstmt.executeUpdate();

            ResultSet rs = pstmt.getGeneratedKeys();
            if (rs.next()) {
                usuario.setIdUsuario(rs.getInt(1));
            }

            pstmt.close();
            conexao.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void alterar(Usuario usuario) {
        Connection conexao = ConnectionFactory.getConnection();
        String sql = "UPDATE Usuarios SET nome = ?, email = ?, senha = ? WHERE idUsuario = ?";
        
        try {
            PreparedStatement pstmt = conexao.prepareStatement(sql);
            pstmt.setString(1, usuario.getNome());
            pstmt.setString(2, usuario.getEmail());
            pstmt.setString(3, usuario.getSenha());
            pstmt.setInt(4, usuario.getIdUsuario());
            pstmt.executeUpdate();

            pstmt.close();
            conexao.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void excluir(int idUsuario) {
        Connection conexao = ConnectionFactory.getConnection();
        String sql = "DELETE FROM Usuarios WHERE idUsuario = ?";
        
        try {
            PreparedStatement pstmt = conexao.prepareStatement(sql);
            pstmt.setInt(1, idUsuario);
            pstmt.executeUpdate();

            pstmt.close();
            conexao.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public Usuario pesquisarPorCodigo(int idUsuario) {
        Usuario usuario = null;
        Connection conexao = ConnectionFactory.getConnection();
        String sql = "SELECT idUsuario, nome, email, senha FROM Usuarios WHERE idUsuario = ?";
        
        try {
            PreparedStatement pstmt = conexao.prepareStatement(sql);
            pstmt.setInt(1, idUsuario);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                usuario = new Usuario();
                usuario.setIdUsuario(rs.getInt("idUsuario"));
                usuario.setNome(rs.getString("nome"));
                usuario.setEmail(rs.getString("email"));
                usuario.setSenha(rs.getString("senha"));
            }

            rs.close();
            pstmt.close();
            conexao.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return usuario;
    }

    public ArrayList<Usuario> pesquisarTodos() {
        ArrayList<Usuario> usuarios = new ArrayList<>();
        Connection conexao = ConnectionFactory.getConnection();
        String sql = "SELECT idUsuario, nome, email, senha FROM Usuarios";
        
        try {
            PreparedStatement pstmt = conexao.prepareStatement(sql);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Usuario usuario = new Usuario();
                usuario.setIdUsuario(rs.getInt("idUsuario"));
                usuario.setNome(rs.getString("nome"));
                usuario.setEmail(rs.getString("email"));
                usuario.setSenha(rs.getString("senha"));
                usuarios.add(usuario);
            }

            rs.close();
            pstmt.close();
            conexao.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return usuarios;
    }
}