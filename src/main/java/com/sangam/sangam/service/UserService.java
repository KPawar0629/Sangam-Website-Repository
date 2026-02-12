package com.sangam.sangam.service;

import com.sangam.sangam.model.User;
import com.sangam.sangam.repo.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;

@Service
public class UserService {

    @Autowired
    private UserRepository repository;

    public User addUser(User user) {
        return repository.save(user);
    }

    public List<User> findAllUsers() {
        return repository.findAll();
    }

    public Optional<User> findUserById(String userId) {
        return repository.findById(userId);
    }

    public void findUserNameById(String userId) {
        System.out.println("in here!");
    }

    public List<User> findUserByFullName(String userName) {
        return repository.findByFullName(userName);
    }

    public Optional<User> findUserByEmail(String email) {
        return repository.findByEmail(email);
    }

    public User updateUser(User user) {
        //Get the existing user from db
        User existingUser = repository.findById(user.getUserId()).get();
        //replace new info to existing user
        existingUser.setFullName(user.getFullName());
        existingUser.setEmail(user.getEmail());
        existingUser.setPassword(user.getPassword());
        existingUser.setPhone(user.getPhone());
        existingUser.setAccount_created(user.getAccount_created());

        return repository.save(existingUser);
    }

    public Optional<User> getUserByUserId(String userId) {
        return repository.findByUserId(userId);
    }

    public String deleteUser(String userId) {
        repository.deleteById(userId);
        return "User deleted";
    }

    public long userCount() {
        return repository.count();
    }

    public User setToken(User user, String tokenValue) {
        User existingUser = getUserByUserId(user.getUserId()).get();

        existingUser.setAuthToken(tokenValue);

        return repository.save(existingUser);
    }

    public Optional<User> getUserByToken(String token) {
        return repository.findByAuthToken(token);
    }

    public boolean validateToken(String token) {
        var user = getUserByToken(token);
        if(user.isPresent() && !user.isEmpty()) {
            return true;
        } else {
            return false;
        }
    }
}
