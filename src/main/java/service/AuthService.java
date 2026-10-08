package service;

import model.Utilisateur;
import org.mindrot.jbcrypt.BCrypt;
import repository.AuthRepository;

import java.util.Optional;

public class AuthService {

    private final AuthRepository authRepository;

    public AuthService() {
        this.authRepository = new AuthRepository();
    }

    public void register(Utilisateur staff, String plainPassword) throws Exception {
        Optional<Utilisateur> existingStaff = authRepository.findByEmail(staff.getEmail());
        if (existingStaff.isPresent()) {
            throw new Exception("email incorrect !");
        }

        String hashedPassword = BCrypt.hashpw(plainPassword, BCrypt.gensalt());
        staff.setPassword(hashedPassword);

        authRepository.save(staff);
    }

    public Utilisateur login(String email, String plainPassword) throws Exception {
        Optional<Utilisateur> optionalStaff = authRepository.findByEmail(email);

        if (optionalStaff.isEmpty()) {
            throw new Exception("Email incorrect.");
        }

        Utilisateur staff = optionalStaff.get();

        boolean isPasswordMatch = BCrypt.checkpw(plainPassword, staff.getPassword());

        if (!isPasswordMatch) {
            throw new Exception("password incorrect.");
        }

        return staff;
    }
}