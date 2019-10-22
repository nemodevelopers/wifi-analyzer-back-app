package ru.nemodev.wifi.analyzer.security.api.processor;

import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import ru.nemodev.wifi.analyzer.security.api.dto.user.UserDto;
import ru.nemodev.wifi.analyzer.security.api.dto.user.UserSaveDto;
import ru.nemodev.wifi.analyzer.security.entity.user.User;
import ru.nemodev.wifi.analyzer.security.service.user.UserService;

import java.util.List;
import java.util.Optional;

/**
 * created by simanov-an
 */
public class UserProcessor {

    private final UserService userService;

    public UserProcessor(UserService userService) {
        this.userService = userService;
    }

    public List<UserDto> findBy(Integer page, Integer size) {
        if (page == null) {
            page = 0;
        }
        if (size == null) {
            size = 10;
        }

        List<User> users = userService.findBy(PageRequest.of(page, size,
                Sort.by(Sort.Direction.DESC, "enabled")));

        return UserDto.fromEntityList(users);
    }

    public Optional<UserDto> findById(String id) {
        Optional<User> userOptional = userService.findById(id);
        if (userOptional.isEmpty()) {
            return Optional.empty();
        }

        return Optional.of(UserDto.fromEntity(userOptional.get()));
    }

    public UserDto create(UserSaveDto userSaveDto) {
        User user = new User();
        user.setLogin(userSaveDto.getLogin());

        return UserDto.fromEntity(userService.create(user, userSaveDto.getPassword(), userSaveDto.isAdmin()));
    }

    public void deleteById(String id) {
        userService.deleteById(id);
    }

}
