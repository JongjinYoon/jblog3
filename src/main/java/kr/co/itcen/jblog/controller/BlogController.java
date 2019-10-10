package kr.co.itcen.jblog.controller;

import java.util.Optional;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import kr.co.itcen.jblog.service.BlogService;
import kr.co.itcen.jblog.vo.BlogVo;
import kr.co.itcen.jblog.vo.CategoryVo;
import kr.co.itcen.jblog.vo.UserVo;

@Controller
@RequestMapping("/{id:(?!assets).*}")
public class BlogController {
	@Autowired
	private BlogService blogService;

	@RequestMapping(value = { "", "/{pathNo1}", "/{pathNo1}/{pathNo2}" }, method = RequestMethod.GET)
	public String index(@PathVariable String id, @PathVariable Optional<Long> pathNo1,
			@PathVariable Optional<Long> pathNo2, ModelMap modelMap) {

		Long categoryNo = 0L;
		Long postNo = 0L;

		if (pathNo2.isPresent()) {
			postNo = pathNo2.get();
			categoryNo = pathNo1.get();
		} else if (pathNo1.isPresent()) {
			postNo = pathNo1.get();
		}

		// modelMap.putAll( blogService.getAll( id, categoryNo, postNo ) );
		return "blog/blog-main";
	}

	@RequestMapping(value = "/blog-admin-basic", method = RequestMethod.GET)
	public String basic(HttpSession session, Model model) {
		UserVo authUser = (UserVo) session.getAttribute("authUser");
		BlogVo blogVo = blogService.getId(authUser.getId());
		model.addAttribute("vo", blogVo);
		return "blog/blog-admin-basic";
	}

	@RequestMapping(value = "/blog-admin-basic", method = RequestMethod.POST)
	public String basic(
			@ModelAttribute BlogVo vo,
			@RequestParam(value = "logo", required = false) MultipartFile multipartFile, Model model) {
		System.out.println(multipartFile);
		String url = blogService.restore(multipartFile);
		vo.setLogo(url);
		System.out.println(vo);
		blogService.update(vo);
		return "redirect:/blog-main";
	}
	
	@RequestMapping(value = "/blog-admin-category", method = RequestMethod.GET)
	public String category(HttpSession session, Model model) {
		UserVo authUser = (UserVo) session.getAttribute("authUser");
		BlogVo blogVo = blogService.getId(authUser.getId());
		model.addAttribute("vo", blogVo);
		return "blog/blog-admin-category";
	}
	
	@RequestMapping(value = "/blog-admin-category", method = RequestMethod.POST)
	public String category(HttpSession session, @ModelAttribute CategoryVo vo) {
		UserVo authUser = (UserVo) session.getAttribute("authUser");
		BlogVo blogVo = blogService.getId(authUser.getId());
		vo.setBlogId(blogVo.getId());
		System.out.println(vo);
		blogService.insert(vo);
		return "redirect:/blog-admin-category";
	}
	
	
	@RequestMapping(value = "/blog-admin-write", method = RequestMethod.GET)
	public String write(HttpSession session, Model model) {
		UserVo authUser = (UserVo) session.getAttribute("authUser");
		BlogVo blogVo = blogService.getId(authUser.getId());
		model.addAttribute("vo", blogVo);
		return "blog/blog-admin-write";
	}

	@ResponseBody
	@RequestMapping("/admin/basic")
	public String adminBasic(@PathVariable String id) {
		return "id:" + id;
	}
	
}
