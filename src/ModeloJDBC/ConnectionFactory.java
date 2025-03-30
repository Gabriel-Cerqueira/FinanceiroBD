package ModeloJDBC;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectionFactory {
	public static Connection getConnection() {
		String stringJDBC = "jdbc:mysql://localhost:3306/sistema_financeiro";
		String usuario = "root";
		String senha = "Tropic@l1912";
		
		Connection conexao = null;
		
		try {
			conexao = DriverManager.getConnection(stringJDBC, usuario, senha);
			
		}catch(SQLException e) {
			e.printStackTrace();
		}
		
		return conexao;

	}
}
