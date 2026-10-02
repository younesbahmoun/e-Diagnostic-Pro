package service;

import model.Staff;
import org.mindrot.jbcrypt.BCrypt;
import repository.AuthRepository;

import java.util.Optional;

public class AuthService {

    private final AuthRepository authRepository;

    public AuthService() {
        this.authRepository = new AuthRepository();
    }

    public void register(Staff staff, String plainPassword) throws Exception {
        Optional<Staff> existingStaff = authRepository.findByEmail(staff.getEmail());
        if (existingStaff.isPresent()) {
            throw new Exception("email incorrect !");
        }

        String hashedPassword = BCrypt.hashpw(plainPassword, BCrypt.gensalt());
        staff.setPassword(hashedPassword);

        authRepository.save(staff);
    }

    public Staff login(String email, String plainPassword) throws Exception {
        Optional<Staff> optionalStaff = authRepository.findByEmail(email);

        if (optionalStaff.isEmpty()) {
            throw new Exception("Email incorrect.");
        }

        Staff staff = optionalStaff.get();

        boolean isPasswordMatch = BCrypt.checkpw(plainPassword, staff.getPassword());

        if (!isPasswordMatch) {
            throw new Exception("password incorrect.");
        }

        return staff;
    }
}